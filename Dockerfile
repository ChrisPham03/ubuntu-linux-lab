# syntax=docker/dockerfile:1.6
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME=learner

# --- Core packages ----------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essentials
    sudo curl wget git ca-certificates gnupg lsb-release \
    # Editors & pagers
    vim nano less man-db manpages manpages-dev \
    # Networking tools
    iputils-ping net-tools dnsutils traceroute iproute2 \
    # System inspection
    tree htop procps psmisc lsof strace \
    # Shell & multiplexer
    zsh tmux \
    # Dev basics
    build-essential python3 python3-pip \
    # Archives & utils
    unzip zip tar jq \
    # Locales
    locales tzdata \
    # Modern CLI tools available in apt
    bat fd-find ripgrep fzf zoxide \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# --- eza (modern `ls`) ------------------------------------------------------
# Works on both arm64 (M-series) and amd64
RUN mkdir -p /etc/apt/keyrings \
    && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
       | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
       > /etc/apt/sources.list.d/gierens.list \
    && apt-get update && apt-get install -y eza \
    && rm -rf /var/lib/apt/lists/*

# --- Starship prompt --------------------------------------------------------
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# --- Symlinks for Ubuntu-renamed binaries -----------------------------------
RUN ln -sf /usr/bin/batcat /usr/local/bin/bat \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd

# --- Non-root user ----------------------------------------------------------
RUN useradd -m -s /usr/bin/zsh ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# --- oh-my-zsh + plugins ----------------------------------------------------
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
       ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
       ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && git clone --depth 1 https://github.com/zsh-users/zsh-completions \
       ${HOME}/.oh-my-zsh/custom/plugins/zsh-completions

# --- Configs ----------------------------------------------------------------
RUN mkdir -p ${HOME}/.config ${HOME}/workspace
COPY --chown=${USERNAME}:${USERNAME} config/.zshrc        /home/${USERNAME}/.zshrc
COPY --chown=${USERNAME}:${USERNAME} config/starship.toml /home/${USERNAME}/.config/starship.toml
COPY --chown=${USERNAME}:${USERNAME} config/.tmux.conf    /home/${USERNAME}/.tmux.conf

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm-256color

WORKDIR /home/${USERNAME}/workspace

CMD ["/usr/bin/zsh"]
