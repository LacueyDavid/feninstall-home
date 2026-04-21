# Architecture

This repository configures a NixOS machine (and optionally a VM) using a
single flake. It is split along **three orthogonal axes**:

| Axis           | Where it lives         | What it answers                |
| -------------- | ---------------------- | ------------------------------ |
| **Host**       | `hosts/`               | *Which machine are we building?* |
| **Concern**    | `modules/system/` + `modules/home/` | *What does the config do?* (one file = one concern) |
| **Content**    | `dotfiles/`            | *What raw (non-Nix) files get deployed?* |

A host picks some concerns; concerns reference raw content. No file mixes
two axes — that's the core invariant.

---

## Directory layout

```
/etc/nixos/
├── ARCHITECTURE.md            # this file
├── CLAUDE.md                  # working notes + known pitfalls
├── README.md                  # compat contract with the bootstrap installer
├── flake.nix                  # inputs + the three outputs: pc / vm / default
├── flake.lock
│
├── hosts/                     ── HOST AXIS
│   ├── default.nix            # shared base: imports modules/system
│   ├── pc.nix                 # physical profile: adds autoUpgrade
│   └── vm.nix                 # virtual profile: virtio drivers + sway fallback
│
├── modules/
│   ├── system/                ── CONCERN AXIS (NixOS side)
│   │   ├── default.nix        # aggregator — imports every sibling
│   │   ├── boot.nix           # LUKS + LVM filesystems + initrd + zram
│   │   ├── nix.nix            # nix settings, GC, allowUnfree, stateVersion
│   │   ├── locale.nix         # timezone, locale, console
│   │   ├── hardware.nix       # graphics, bluetooth, firmware, upower
│   │   ├── network.nix        # NetworkManager + firewall + SSH
│   │   ├── audio.nix          # pipewire + rtkit
│   │   ├── desktop.nix        # Hyprland + greetd + portals + session launcher
│   │   └── users.nix          # `seth` user + global env vars + rescue CLI
│   │
│   ├── home/                  ── CONCERN AXIS (home-manager side)
│   │   ├── default.nix        # aggregator
│   │   ├── shell.nix          # zsh + git + fzf + zoxide + eza + bat + delta + direnv
│   │   ├── terminal.nix       # kitty
│   │   ├── editor.nix         # nixvim (LSP, treesitter, plugins)
│   │   ├── apps.nix           # firefox, mupdf, telegram, vscode
│   │   ├── packages.nix       # CLI dev tooling (claude-code, nixd, ripgrep, …)
│   │   ├── hyprland.nix       # overrides illogical-impulse Hyprland .conf files
│   │   └── quickshell.nix     # quickshell config (ii + default alias)
│   │
│   └── illogical-impulse/     ── VENDORED third-party HM module
│       ├── modules/           # options, quickshell, hyprland, packages
│       ├── pkgs/              # custom package definitions
│       └── README.md
│
├── home/                      ── HOME-MANAGER ENTRY POINTS
│   ├── seth.nix               # imports modules/home + illogical-impulse + nixvim
│   └── root.nix               # minimal
│
└── dotfiles/                  ── CONTENT AXIS (raw, non-Nix)
    └── hypr/
        ├── hyprland.conf
        ├── monitors.conf
        ├── workspaces.conf
        ├── hyprland/          # sourced by hyprland.conf
        │   ├── execs.conf     # exec-once commands (autostarts)
        │   ├── keybinds.conf
        │   ├── general.conf
        │   ├── rules.conf
        │   ├── colors.conf
        │   ├── env.conf
        │   └── scripts/       # helper shell scripts
        ├── custom/            # user overrides layered on top
        │   └── …
        ├── hyprlock/
        └── quickshell/ii/     # QML source for the Wayland shell
```

---

## Data flow: how a rebuild resolves

```
   flake.nix                      (nixosConfigurations.pc)
     │
     ├── hosts/pc.nix              ── HOST
     │     └── hosts/default.nix
     │           └── modules/system/default.nix
     │                 ├── boot.nix, nix.nix, locale.nix, hardware.nix,
     │                 ├── network.nix, audio.nix, users.nix
     │                 └── desktop.nix          ── Hyprland + greetd + session launcher
     │
     └── home-manager.nixosModules.home-manager (injected by flake.nix)
           └── home/seth.nix                    ── HM ENTRY
                 ├── inputs.nixvim.homeModules.nixvim
                 ├── modules/illogical-impulse/modules        ── vendored baseline
                 │     └── installs quickshell/ii + hypr/… from upstream
                 └── modules/home/default.nix   ── CONCERNS
                       ├── shell.nix, terminal.nix, editor.nix,
                       ├── apps.nix, packages.nix
                       ├── hyprland.nix    ── lib.mkForce → dotfiles/hypr/...
                       └── quickshell.nix  ── lib.mkForce → dotfiles/hypr/quickshell/ii
```

The key asymmetry: **illogical-impulse runs first and installs the upstream
dots; our own `modules/home/hyprland.nix` and `quickshell.nix` then override
individual files using `lib.mkForce`.** That lets us ship local fixes without
forking the vendored module.

---

## Conventions

- **One concern per file**. If `modules/system/desktop.nix` starts doing
  networking, split it. Files stay under ~80 lines where possible.
- **Hosts don't configure; they compose.** `hosts/*.nix` only imports and
  sets host-specific options (autoUpgrade, initrd drivers). Real logic
  lives in `modules/`.
- **Dotfiles are source of truth for non-Nix config.** If Hyprland reads a
  `.conf`, the `.conf` lives under `dotfiles/` — never embedded as a
  multi-line Nix string.
- **Override upstream, don't fork it.** The `modules/illogical-impulse/`
  tree is vendored and treated as read-only. Patches happen in our own
  `modules/home/*.nix` via `lib.mkForce`.
- **Secrets never touch the Nix store.** API keys live in `~/.secrets/*.env`
  and are sourced at shell init.

---

## Adding things — recipes

| You want to…                              | Edit this                                   |
| ----------------------------------------- | ------------------------------------------- |
| Add a system package available to all     | `modules/system/users.nix` → `systemPackages` |
| Add a user-only CLI tool                  | `modules/home/packages.nix`                 |
| Add a new shell alias                     | `modules/home/shell.nix` → `shellAliases`   |
| Enable a new Neovim plugin / LSP          | `modules/home/editor.nix`                   |
| Add a Hyprland keybind                    | `dotfiles/hypr/custom/keybinds.conf`        |
| Change a Hyprland rule temporarily        | `dotfiles/hypr/custom/rules.conf`           |
| Override an upstream illogical-impulse file | add an `xdg.configFile` entry with `lib.mkForce` in `modules/home/hyprland.nix` |
| Support a new host                        | create `hosts/<name>.nix`, register in `flake.nix` |

---

## Rebuilding

```bash
fst        # test  (reversible, skips bootloader write)
fss        # switch (applies + updates bootloader)
```

Both aliases expand to `sudo nixos-rebuild {test,switch} --flake /etc/nixos#pc`.

Before a switch, always: `nix flake check --no-build`.
