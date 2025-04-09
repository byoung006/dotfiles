## .dotfiles 🛠️
This repository contains my personal dotfiles, configuration files that customize the look and behavior of my system and applications.  
These are primarily for a Linux environment although these could be adapted for mac-os and likely wsl.

## What's Included:
Here's a breakdown of the key configurations you'll find in this repository:

`.bashrc`:  Customizes the interactive shell.

`.bash_aliases`:  Just some personal preferences I've collected along the way - come at me bro.

`bin/`: Handy script stolen from [theprimagen](https://github.com/theprimeagen) for tmux session management

`ghostty/`: My ghostty config - catppuccin for the win.

`nvim/`:  My nvim config - please see the attached submodule

`sesh/`: Tmux sessionizer plugin

`starship/`: Makes my terminal pretty

`tmux/`: Could be the best thing since sliced bread. 

  #### plugins/:
  `tpm`: Tmux Plugin Manager. This is a plugin manager for Tmux, used to easily install, update, and manage other Tmux plugins.
    
  `tmux-resurrect`: This plugin is used to save and restore Tmux sessions across system restarts. It allows you to persist your Tmux environment.
    
  `tmux-continuum`: This plugin works with tmux-resurrect to automatically save your Tmux sessions at a specified interval.
    
  `tmux-yank`: This plugin enables you to easily copy text from Tmux to the system's clipboard.
    
  `tmux2k`: This is a theme for the Tmux status bar.

#### Stow: 
  Using stow, we can create sym-links to the configurations in our `~/.dotfiles` directory

### Installation: 
`git clone https://github.com/byoung006/dotfiles.git`

`cd dotfiles`

`chmod +x install.sh` 

> **Warning:** This bootstraps my own preferences, make sure you want what's in the `packages.conf` file before running the install

`./install.sh`

`stow */`



