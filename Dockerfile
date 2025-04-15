FROM archlinux:latest

COPY ./mirrorlist /etc/pacman.d/mirrorlist

ENV SCREEN=1

# ============================================================================
# Install keyring, initialize key and upgrade system
# ----------------------------------------------------------------------------
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman-key --init && pacman-key --populate && \
    pacman -Syu --noconfirm
# ============================================================================


# ============================================================================
# Install base packages, fonts and packages
# ----------------------------------------------------------------------------
RUN pacman -S --noconfirm base base-devel

RUN pacman -S --noconfirm \
    otf-ipafont \
    ttf-fira-code \
    woff-fira-code \
    woff2-fira-code \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra \
    adobe-source-code-pro-fonts \
    adobe-source-sans-fonts \
    adobe-source-serif-fonts \
    ttf-liberation \
    ttf-dejavu \
    ttf-roboto

RUN pacman -S --noconfirm \
    tigervnc \
    firefox \
    xorg-server \
    dbus \
    sudo \
    neovim \
    git \
    yazi \
    zsh \
    tilix \
    gnome-themes-extra \
    bc \
    iw \
    wireless_tools \
    podman \
    podman-compose \
    pavucontrol \
    pipewire-pulse \
    fuse-overlayfs

RUN pacman -S --noconfirm i3-wm rofi i3blocks networkmanager network-manager-applet
RUN pacman -S --noconfirm libxslt

RUN dbus-uuidgen > /etc/machine-id && \
    ln -sf /etc/machine-id /var/lib/dbus/machine-id

# ============================================================================


# ============================================================================
# Create a new user and add to the wheel group
# ----------------------------------------------------------------------------
RUN useradd -m -G wheel -s /bin/zsh vncuser
COPY --chown=vncuser:vncuser ./config /home/vncuser/.config
COPY --chown=vncuser:vncuser ./local /home/vncuser/.local
COPY --chown=vncuser:vncuser ./mozilla /home/vncuser/.mozilla
RUN echo "vncuser:vncpass" | chpasswd
# ============================================================================


# ============================================================================
# Install Yay AUR helper
# ----------------------------------------------------------------------------
RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

USER vncuser

RUN mkdir -p $HOME/pkgs && \
    cd $HOME/pkgs && \
    git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -si --noconfirm

# Switch back to root to set system-wide preferences
USER root

RUN echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers
# ============================================================================


# ============================================================================
# Enable Dark Theme System Wide
# ----------------------------------------------------------------------------
RUN echo 'export GTK_THEME=Adwaita:dark' > /etc/profile.d/dark-theme.sh

USER vncuser

ENV GTK_THEME=Adwaita:dark
# ============================================================================

# ============================================================================
# Configure User Environment
# ----------------------------------------------------------------------------
ENV HOME=/home/vncuser

WORKDIR /home/vncuser

RUN echo "y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN chown -R vncuser:vncuser $HOME
# ============================================================================


# ============================================================================
# Configure VNC Server
# ----------------------------------------------------------------------------
RUN mkdir -p $HOME/.vnc && \
    echo '#!/bin/sh\nexec i3' > $HOME/.vnc/xstartup && \
    chmod +x $HOME/.vnc/xstartup

RUN echo -e "vncpass\nvncpass\n" | vncpasswd
# ============================================================================


CMD ["sh", "-c", "vncserver :$SCREEN && tail -F /dev/null"]
