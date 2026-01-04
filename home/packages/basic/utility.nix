{
  pkgs,
  enable_utility_pkgs ? true,
  ...
}:
with pkgs;
let

  utility_pkgs =
    if enable_utility_pkgs then [
      # # hardware
      # bluez-tools
      # cdrtools
      efibootmgr
      # freeipmi
      hddtemp
      # inetutils
      # ipmitool
      # jmtpfs
      # lm_sensors
      parted
      # pciutils
      # ps_mem
      # psmisc
      smartmontools
      # usbutils
      vulkan-tools

      # # basic
      # cabextract
      # devenv
      # duf
      # fd
      # fig2dev
      # file
      # fltrdr
      # perf
      # rnm
      scooter
      # socat
      # sysvinit
      # tealdeer
      # tree
      # ueberzugpp
      # vale
      # vdhcoapp
      # w3m
      # wimlib
      # wmctrl
      # xdg-utils

      # # managing
      bluetui
      # bluetuith
      bootiso
      # caligula
      # gobang
      impala
      # mdadm
      # nvme-cli
      # systemctl-tui
      # tui-journal

      # # security
      # hexyl
      # nmap
      # rustscan

      # # torrent
      # nyaa
      rtorrent
      # rustmission

      # # keyboard
      # gtypist
      # kbt
      # thokr
      # tickrs
      # toipe
      # tt
      # ttyper
      # typioca
      # typos
      # typst

      # # database
      # harlequin
      # lazysql
      # rainfrog

      # password store
      gopass
      gopass-hibp
      gopass-jsonapi
      gopass-summon-provider
      git-credential-gopass
      
      # # productivity
      # aichat
      # croc
      fdroidcl
      # fontfor
      # gdrive3
      gtt
      # mermaid-cli
      # n-m3u8dl-re
      # peaclock
      # clock-rs
      # pom
      # presenterm
      # projectable
      qrcp
      # tuifeed

      # # todo
      # dooit
      # dstask
      # taskwarrior-tui
      # todoman
      # ttdl

      # # transfer
      # ffsend
      # portal
      # termscp

      # # remote
      # tmate
      # upterm

      # gog, ssh & git
      fast-ssh
      git-filter-repo
      gitu
      smassh

      # # nix
      # nix-health
      # nix-index
      nix-search-cli
      # vulnix

      # # internet
      # lynx
      # manga-tui
      # so

      # # social
      # gurk-rs
      # reddit-tui
      # toot
      # tut

      # # development
      # jsonnet
      lazyjj
      radian
      scrcpy
      # silicon

      # # unfree
      unrar

      # clipboard
      wl-clipboard
    ]
    else
      [];
in {

  inherit utility_pkgs;
}

