# Ubuntu Linux Lab

A zero-hassle Ubuntu 24.04 LTS terminal environment for macOS (Apple Silicon M1/M2/M3 and Intel), designed for practicing Linux commands. Spin it up, play around, break things, reset — all without touching your host system.

> This repo sets up the **environment only**. Pick any Linux course/book/tutorial you like and run the commands here.

---

## What you get

- **Ubuntu 24.04 LTS** container running natively on Apple Silicon (arm64)
- **zsh** with oh-my-zsh + syntax highlighting + autosuggestions + completions
- **Starship** prompt — fast, clean, informative
- **tmux** preconfigured with `Ctrl-a` prefix and sensible defaults
- **Modern CLI tools**: `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `htop`, `tree`, `jq`
- **Classic tools** kept intact: `ls`, `grep`, `find`, `cat`, `less`, `vim`, `nano`, `man`, `iproute2`, `net-tools`, `strace`, `lsof`, and more — so you learn real Linux, not just aliases
- **Persistent workspace** — files in `./workspace` on your Mac are mounted into the container
- **Passwordless sudo** for the `learner` user, so you can practice admin commands freely
- **Make targets** for all common actions

---

## Prerequisites

You need **one** of:

- [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/) — official, works everywhere
- [OrbStack](https://orbstack.dev) — faster, lighter alternative, highly recommended on Apple Silicon

Both are free for personal use.

---

## Quick start

```bash
git clone <your-repo-url> ubuntu-linux-lab
cd ubuntu-linux-lab

# One-time build (takes ~2–3 minutes)
./scripts/setup.sh

# Enter the lab
make shell
```

That's it. You're now inside Ubuntu as the `learner` user, with a nice prompt and all tools ready.

---

## Daily use

```bash
make shell     # enter the lab (starts container if needed)
make down      # stop it when you're done
make up        # start it again later
make status    # see if it's running
make help      # list everything
```

When you run `exit` inside the container, it keeps running in the background so you can reconnect instantly with `make shell`. Use `make down` when you actually want to stop it.

---

## Recommended host terminal

Your Mac's terminal is what you see the container through, so treat yourself:

| Terminal | Notes |
|---|---|
| [Ghostty](https://ghostty.org) | Fast, modern, great defaults |
| [WezTerm](https://wezfurlong.org/wezterm/) | Highly configurable |
| [iTerm2](https://iterm2.com) | Classic, feature-rich |
| [Warp](https://www.warp.dev) | AI-powered, modern UI |
| Terminal.app | Built-in, works fine |

For the Starship prompt icons to render, install a **Nerd Font** (e.g. [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)) and set it as your terminal's font.

---

## File layout

```
ubuntu-linux-lab/
├── Dockerfile              # Ubuntu 24.04 + tools + user setup
├── docker-compose.yml      # Container orchestration
├── Makefile                # Convenient commands
├── config/
│   ├── .zshrc              # Shell config, aliases, banner
│   ├── starship.toml       # Prompt configuration
│   └── .tmux.conf          # tmux configuration
├── scripts/
│   ├── setup.sh            # First-time setup script
│   └── enter.sh            # Alternative to `make shell`
├── workspace/              # Mounted into container at ~/workspace
├── .gitignore
├── LICENSE
└── README.md
```

---

## Workspace persistence

- **`./workspace` on your Mac** ↔ **`~/workspace` in the container**. Anything you create here survives container rebuilds and is editable with your Mac editor (VS Code, etc.).
- The rest of `/home/learner` lives in a Docker volume (`learner-home`) and persists across `make down`/`make up` but is wiped by `make reset` or `make clean`.

---

## Customizing

- Edit `config/.zshrc` or `config/starship.toml`, then run `make rebuild` to bake in the changes.
- Prefer a different theme? Replace `config/starship.toml` with any preset from [starship.rs/presets](https://starship.rs/presets/).
- Need more packages? Add them to the `apt-get install` lines in the `Dockerfile` and `make rebuild`.

---

## Resetting

Broke something? Want a fresh system?

```bash
make reset     # destroys container + volumes, rebuilds, restarts (files in ./workspace survive)
make clean     # just nukes everything, no rebuild
```

---

## Notes for Apple Silicon (M1/M2/M3)

Everything runs **natively on arm64** — no Rosetta, no emulation, no slowness. The `ubuntu:24.04` base image, Starship, eza, and all apt packages have proper arm64 builds.

If you ever need to test something under x86_64 emulation, uncomment `platform: linux/arm64` in `docker-compose.yml` and change it to `linux/amd64` — but you won't need this for general Linux practice.

---

## Troubleshooting

**"Cannot connect to the Docker daemon"** — Start Docker Desktop or OrbStack.

**Prompt icons look like boxes** — Install a Nerd Font and set it in your terminal.

**`make: command not found`** — macOS ships with `make`, but if you stripped your system, install Xcode Command Line Tools: `xcode-select --install`.

**Want to share the container with another terminal tab?** — `docker compose exec ubuntu-learn zsh` works from any terminal; open as many as you like.

---

## License

MIT — do whatever you want with it.
