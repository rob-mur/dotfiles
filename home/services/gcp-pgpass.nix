# Cloud SQL IAM authentication without the copy-paste.
#
# An IAM database user has no password: the password IS a short-lived OAuth
# access token. The token expires after an hour, which is why the token has to
# be pasted into DBeaver again and again.
#
# This writes the current token into ~/.pgpass and refreshes it every 45
# minutes, so both DBeaver and libpq pick it up on their own.
#
#   DBeaver:  set Authentication to "PostgreSQL pgpass", user to iamUser below
#   python:   PGPASSWORD=$(pgtoken) python app.py
#   psql:     psql -h <ip> -U <iamUser> -d <db>        (reads ~/.pgpass)
#
# Override the account with PGIAM_USER. Run `gcp-pgpass` by hand to refresh now.
{pkgs, ...}: let
  # The Cloud SQL IAM user name is the full account email.
  iamUser = "robert.murphy@descartesunderwriting.com";

  gcloud = "${pkgs.google-cloud-sdk}/bin/gcloud";

  pgtoken = pkgs.writeShellApplication {
    name = "pgtoken";
    text = ''
      exec ${gcloud} auth print-access-token
    '';
  };

  gcp-pgpass = pkgs.writeShellApplication {
    name = "gcp-pgpass";
    runtimeInputs = [pkgs.coreutils];
    text = ''
      user="''${PGIAM_USER:-${iamUser}}"
      pgpass="$HOME/.pgpass"

      token=$(${gcloud} auth print-access-token)
      if [ -z "$token" ]; then
        echo "gcp-pgpass: no token. Run 'gcloud auth login' first." >&2
        exit 1
      fi

      # Keep any hand-written lines, replace only the one this owns.
      tmp=$(mktemp)
      trap 'rm -f "$tmp"' EXIT
      if [ -f "$pgpass" ]; then
        grep -v ":$user:" "$pgpass" >"$tmp" || true
      fi
      # host:port:database:user:password, wildcards for the first three, so a
      # new IAM database needs no change here.
      echo "*:*:*:$user:$token" >>"$tmp"

      install -m 600 "$tmp" "$pgpass"
    '';
  };
in {
  home.packages = [pgtoken gcp-pgpass];

  systemd.user.services.gcp-pgpass = {
    Unit = {
      Description = "Write the Cloud SQL IAM token into ~/.pgpass";
      After = ["network-online.target"];
      # The path unit can fire several times per login. Do not rate limit it.
      StartLimitIntervalSec = 0;
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${gcp-pgpass}/bin/gcp-pgpass";
    };
  };

  systemd.user.timers.gcp-pgpass = {
    Unit.Description = "Refresh the Cloud SQL IAM token before it expires";

    Timer = {
      # The token lasts an hour. Refresh well inside that.
      OnStartupSec = "1m";
      OnUnitActiveSec = "45m";
      Persistent = true;
    };

    Install.WantedBy = ["timers.target"];
  };

  # Workload identity federation logs us out once a day, the limit Google
  # allows. gcloud rewrites credentials.db on the next login, so watch it and
  # refresh ~/.pgpass straight away, rather than waiting for the timer.
  systemd.user.paths.gcp-pgpass = {
    Unit.Description = "Refresh the Cloud SQL IAM token after a gcloud login";

    Path = {
      PathChanged = "%h/.config/gcloud/credentials.db";
      Unit = "gcp-pgpass.service";
    };

    Install.WantedBy = ["paths.target"];
  };
}
