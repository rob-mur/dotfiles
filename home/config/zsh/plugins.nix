# oh-my-zsh plugins. Note what is deliberately absent: autojump, fzf and
# direnv. home-manager's own programs.{autojump,fzf,direnv} modules are
# enabled on every host (home/minimal.nix, home/programs/default.nix) and
# already append their init to the end of .zshrc, so the matching oh-my-zsh
# plugins just load the same hooks a second time and add their directories
# to $fpath for nothing. On a laptop that's noise; on nix-on-droid, where
# every file read goes through proot, it was ~260ms of every shell start.
[
  "git"
  "aliases"
  "alias-finder"
  "branch"
  "command-not-found"
  "copybuffer"
  "copyfile"
  "copypath"
  "dircycle"
  "emoji"
  "gcloud"
  "docker"
  "docker-compose"
  "git-auto-fetch"
  "git-prompt"
  "helm"
  "npm"
  "python"
  "pip"
  "virtualenv"
  "ssh"
  "sudo"
  "tmux"
]
