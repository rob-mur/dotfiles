{ pkgs, ... }: let

  profile = import ./../../user/profile {};

in {
  home-manager = {
    users.${profile.name} = {
      programs = {
        tmux = {
          enable = true;
          clock24 = true;
          historyLimit = 1000000;
          terminal = "tmux-256color";
          extraConfig = ''
	  	set -g prefix ^A
		set -g base-index 1              # start indexing windows at 1 instead of 0
		set -g detach-on-destroy off     # don't exit from tmux when closing a session
		set -g escape-time 0             # zero-out escape time delay
		set -g renumber-windows on       # renumber all windows when any window is closed
		set -g set-clipboard on          # use system clipboard
		set -g status-position top       # macOS / darwin style

		bind-key x kill-window 	# don't ask for confirmation when closing window
		bind-key C-a last-window
		bind-key v split-window -h -c "#{pane_current_path}"
		bind-key s split-window -v -c "#{pane_current_path}"
		bind-key c kill-pane
		bind-key C-c new-window -c "#{pane_current_path}"
		bind -r h select-pane -L
		    bind -r j select-pane -D
		    bind -r k select-pane -U
		    bind -r l select-pane -R

		setw -g mode-keys vi

		set -g pane-active-border-style 'fg=magenta,bg=default'
		set -g pane-border-style 'fg=brightblack,bg=default'

		set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
		set -g @fzf-url-history-limit '2000'
		TMUX_FZF_LAUNCH_KEY="C-space"

		set -g @catppuccin_window_number_position "right"
		set -g @catppuccin_window_default_fill "number"
		set -g @catppuccin_window_default_text "#W"
		set -g @catppuccin_window_current_fill "number"
		set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
		set -g @catppuccin_window_text "#W#{?window_zoomed_flag,(),}"
		set -g @catppuccin_window_status_style "rounded"
          '';
	  plugins = with pkgs.tmuxPlugins ;[
						sensible
						yank
		fingers
						catppuccin
						tmux-fzf
					];
        };
      };
    };
  };
}
