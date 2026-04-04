{ config, pkgs, ... }:
{
  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
    NIXOS_OZONE_WL = "1";
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "seth";
      user.email = "seth@example.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
      rerere.enabled = true;
      core.editor = "nvim";
      alias = {
        s = "status -sb";
        c = "commit";
        a = "add";
        sw = "switch";
        tree = "log --graph --abbrev-commit --decorate --oneline --all";
      };
    };
    ignores = [
      ".DS_Store"
      ".direnv"
      ".idea"
      ".vscode"
      "*.swp"
      "result"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      save = 50000;
      size = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      path = "$HOME/.local/state/zsh/history";
    };

    shellAliases = {
      v = "nvim";
      ls = "eza --group-directories-first";
      ll = "eza -lah --git --group-directories-first";
      lt = "eza --tree --level=2 --git-ignore";
      cat = "bat";
      grep = "rg";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#default";
      nrt = "sudo nixos-rebuild test --flake /etc/nixos#default";
      fenos-switch = "fenos_switch";
      fenos-test = "fenos_test";
      fss = "fenos_switch";
      fst = "fenos_test";
      switch = "fenos_switch";
    };

    initContent = ''
      fenos_flake_path() {
        local candidates
        candidates=(
          "''${FENOS_FLAKE_PATH:-}"
          "/etc/nixos"
          "$HOME/work/nixos-project/feninstall-home"
          "$HOME/nixos-project/feninstall-home"
        )

        local p
        for p in "''${candidates[@]}"; do
          if [[ -n "$p" && -f "$p/flake.nix" ]]; then
            printf "%s" "$p"
            return 0
          fi
        done

        return 1
      }

      fenos_switch() {
        local flake
        flake="$(fenos_flake_path)" || {
          echo "fenos: unable to locate flake. Set FENOS_FLAKE_PATH first."
          return 1
        }
        sudo nixos-rebuild switch --flake "$flake#pc"
      }

      fenos_test() {
        local flake
        flake="$(fenos_flake_path)" || {
          echo "fenos: unable to locate flake. Set FENOS_FLAKE_PATH first."
          return 1
        }
        sudo nixos-rebuild test --flake "$flake#pc"
      }

      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
    '';
  };

  home.packages = with pkgs; [
    alejandra
    bash-language-server
    clang-tools
    fd
    gh
    jq
    lua-language-server
    nil
    nixd
    prettier
    ripgrep
    ruff
    shellcheck
    shfmt
    stylua
    tree
    unzip
    wget
    zip
  ];
}
