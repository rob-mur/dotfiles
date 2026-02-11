{config, ...}: let
  abbr = {
    c = "cp";
    d = "doas";
    f = "fastfetch";
    v = "nvim";
    t = "btop";

    cv = "cava";
    da = "lsblk -o name,fstype,fsavail,fsused,size,mountpoint";
    en = "euporie-notebook";
    ht = "htop";
    jp = "jupyter-lab";
    lg = "libgen-cli -e pdf search";
    mo = "monero-wallet-cli";
    nb = "newsboat";
    nc = "ncmpcpp";
    sc = "scooter";
    sf = "superfile";

    ns = "nix-search";

    qp = "quarto preview";
    qr = "quarto render";

    yt = "yt-dlp";
    yv = "yt-dlp -f bestvideo+bestaudio";
    ym = "yt-dlp -f bestaudio -x --audio-format vorbis";
    te = "tagutil edit";

    ust = "systemctl --user start";
    usp = "systemctl --user stop";
    usr = "systemctl --user restart";
    uss = "systemctl --user status";

    dst = "doas systemctl start";
    dsp = "doas systemctl stop";
    dsr = "doas systemctl restart";
    dss = "doas systemctl status";

    neq = "nix-env -qaP";
    nim = "nix-shell -p nix-info --run 'nix-info -m'";

    nei = "nix-env -iA";
    neu = "nix-env --uninstall";

    nlg = "nix-env --list-generations -p /home/${config.name}/.local/state/nix/profiles/profile";
    hlg = "nix-env --list-generations -p /home/${config.name}/.local/state/nix/profiles/home-manager";
    slg = "doas nix-env --list-generations -p /nix/var/nix/profiles/system";

    ndg = "nix-env --delete-generations old -p /home/${config.name}/.local/state/nix/profiles/profile";
    hdg = "nix-env --delete-generations old -p /home/${config.name}/.local/state/nix/profiles/home-manager";
    sdg = "doas nix-env --delete-generations old -p /nix/var/nix/profiles/system";

    dncl = "doas nix-channel --list";
    dncu = "doas nix-channel --update";
    dnrd = "doas nixos-rebuild dry-build";
    snrs = "zsh -c 'cd ${config.hostDir} && sudo nixos-rebuild switch --flake .#dev'";
    dnru = "doas nixos-rebuild switch --upgrade";
    dngc = "doas nix-store --gc";
    dngd = "doas nix-collect-garbage --delete-old";

    trab = "trans :ab -b";
    tren = "trans :en -b";
    trid = "trans :id -b";
    trja = "trans :ja -b";

    gad = "git add";
    gal = "git add --all";

    gb = "git branch";
    gbl = "git blame -b -w";
    gbr = "git branch --remote";

    gcm = "git commit -m";
    gca = "git commit S --amend";

    gcb = "git checkout -b";
    gck = "git checkout main";

    gcf = "git config --list";
    gcl = "git clone --recursive";
    gcln = "git clean -fd";
    gcp = "git cherry-pick";

    gdf = "git diff";
    gdc = "git diff --cached";

    gfs = "git fetch sh";
    gfg = "git fetch gh";
    gfl = "git fetch gl";
    gfa = "git fetch --all --prune";

    gig = "git update-index --assume-unchanged";

    gls = "git log --stat";
    glsp = "git log --stat -p";
    glg = "git log --graph";
    glo = "git log --decorate --oneline";

    gm = "git merge";
    gmsm = "git merge sh/main";
    gmgm = "git merge gh/main";
    gmlm = "git merge gl/main";
    gmt = "git mergetool --no-prompt";

    gpsm = "git push -u sh main";
    gpgm = "git push -u gh main";
    gplm = "git push -u gl main";

    gr = "git remote";
    gra = "git remote add";
    grv = "git remote --verbose";

    grh = "git reset HEAD";
    grhh = "git reset HEAD --hard";

    gst = "git status -sbu";
    gsps = "git show --pretty=short --show-signature";
    gsts = "git stash show --text";
    gsu = "git submodule update";

    gts = "git tag -s";
    gta = "git tag -a";

    gur = "git pull --rebase";
    gusm = "git pull sh main";
    gugm = "git pull gh main";
    gulm = "git pull gl main";
  };
in {
  inherit abbr;
}
