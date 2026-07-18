{ config, pkgs, ... }:
let
  dots = "${config.home.homeDirectory}/code/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.username = "alex";
  home.homeDirectory = "/Users/alex";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Dotfile links — declarative replacement for ./install. mkOutOfStoreSymlink
  # keeps each link writable and pointed at the dotfiles working copy, so
  # `git config`, the runner, etc. keep working exactly as before.
  home.file = {
    "Library/KeyBindings/DefaultKeyBinding.dict".source = link "${dots}/DefaultKeyBinding.dict";
    ".zshenv".source = link "${dots}/zsh/zshenv";
    ".zshrc".source = link "${dots}/zsh/zshrc";
    ".zprofile".source = link "${dots}/zsh/zprofile";
    ".gitconfig".source = link "${dots}/git/gitconfig";
    ".rgignore".source = link "${dots}/rg/rgignore";
    ".config/nix".source = link "${dots}/nix";
    ".config/nvim".source = link "${dots}/nvim";
    ".config/tmux".source = link "${dots}/tmux";
    ".config/alacritty".source = link "${dots}/alacritty";
    ".config/starship.toml".source = link "${dots}/starship/starship.toml";
    ".config/yt-dlp".source = link "${dots}/yt-dlp";
  };

  home.packages = with pkgs; [
    act cloudflared coreutils docker fd fzy gettext gh git jq mitmproxy
    mosh neovim ripgrep starship stylua tmux toxiproxy tree yt-dlp
  ];
}
