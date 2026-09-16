# vpc — routes the whole VPC range through the bastion, so every private IP
# just works from this machine.
#
# It replaces the per-database `ssh -L` forward: sshuttle builds a userspace
# VPN over the IAP tunnel, so a real URL like
#   postgresql+psycopg://aegis:pwd@10.58.0.8:5432/aegis-db
# connects with no rewriting, from python, psql, DBeaver or curl.
#
#   vpc                    hold the route open until Ctrl-C
#   vpc python app.py      open the route, run the command, close it
#   vpc psql "$URL"        same, for a one-off query
#
# Override per run with VPC_SUBNETS (space separated), VPC_USER and VPC_KEY.
# sshuttle needs sudo locally, and python3 on the bastion.
{pkgs, ...}: let
  instance = "bastion-sql";
  project = "portfolio-dev-402609";
  zone = "europe-west1-b";
  # Every RFC1918 10.x range, so a new database needs no change here.
  defaultSubnets = "10.0.0.0/8";
  gcloud = "${pkgs.google-cloud-sdk}/bin/gcloud";

  vpc = pkgs.writeShellApplication {
    name = "vpc";
    runtimeInputs = [pkgs.sshuttle pkgs.coreutils pkgs.gnugrep pkgs.openssh];
    text = ''
      subnets="''${VPC_SUBNETS:-${defaultSubnets}}"
      user="''${VPC_USER:-$USER}"
      # The bastion trusts the key gcloud manages, not ~/.ssh/id_ed25519.
      key="''${VPC_KEY:-$HOME/.ssh/google_compute_engine}"

      if [ ! -f "$key" ]; then
        echo "vpc: no key at $key" >&2
        echo "vpc: run 'gcloud compute ssh ${instance} --tunnel-through-iap --project=${project} --zone=${zone}' once to create it" >&2
        exit 1
      fi

      proxy="${gcloud} compute start-iap-tunnel ${instance} 22 --listen-on-stdin"
      proxy="$proxy --project=${project} --zone=${zone}"

      # Prime sudo now, so sshuttle does not prompt from the background.
      sudo -v

      log=$(mktemp)
      # shellcheck disable=SC2086
      sshuttle --dns -r "$user@${instance}" \
        -e "ssh -i $key -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o ProxyCommand='$proxy'" \
        $subnets >"$log" 2>&1 &
      tunnel=$!
      trap 'kill "$tunnel" 2>/dev/null || true; rm -f "$log"' EXIT

      ready=
      for _ in $(seq 1 120); do
        if grep -q 'Connected to server' "$log"; then
          ready=1
          break
        fi
        kill -0 "$tunnel" 2>/dev/null || break
        sleep 0.5
      done
      if [ -z "$ready" ]; then
        echo "vpc: the route did not come up:" >&2
        cat "$log" >&2
        exit 1
      fi

      if [ "$#" -eq 0 ]; then
        echo "vpc: $subnets routed through ${instance} (Ctrl-C to close)" >&2
        wait "$tunnel" || true
      else
        "$@"
      fi
    '';
  };
in {
  home.packages = [vpc];
}
