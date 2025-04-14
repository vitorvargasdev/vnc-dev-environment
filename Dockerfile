FROM archlinux:latest

COPY ./mirrorlist /etc/pacman.d/mirrorlist
COPY ./docker-scripts /home/scripts
RUN chmod -R +x /home/scripts/dark-theme.sh

# Install keyring, initialize key and upgrade system
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman-key --init && pacman-key --populate && \
    pacman -Syu --noconfirm

# Install base packages and fonts
RUN pacman -S --noconfirm base base-devel
RUN pacman -S --noconfirm tigervnc firefox xorg-server dbus sudo neovim git yazi zsh tilix \
    gnome-themes-extra bc iw wireless_tools docker docker-compose

RUN pacman -S --noconfirm otf-ipafont \
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

RUN pacman -S --noconfirm i3-wm rofi i3blocks networkmanager network-manager-applet
RUN pacman -S --noconfirm libxslt

# Create a new user and add to the wheel group
RUN useradd -m -G wheel,docker -s /bin/zsh vncuser && \
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers && \
    echo "vncuser:vncpass" | chpasswd


COPY ./preconfigs/config /home/vncuser/.config --chown=vncuser:vncuser
COPY ./config /home/vncuser/.config --chown=vncuser:vncuser
COPY ./local /home/vncuser/.local --chown=vncuser:vncuser

# Switch to user context for AUR helper installation
USER vncuser

RUN mkdir -p $HOME/pkgs && \
    cd $HOME/pkgs && \
    git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -si --noconfirm

# Switch back to root to set system-wide preferences
USER root

# (Re)set sudoers to require password if needed (optional)
RUN echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers

# ============================================================================
# Enable Dark Theme System Wide
# ----------------------------------------------------------------------------
RUN /home/scripts/dark-theme.sh
# ============================================================================

USER vncuser

ENV GTK_THEME=Adwaita:dark
ENV HOME=/home/vncuser

COPY ./config /home/vncuser/.config
WORKDIR /home/vncuser

RUN echo "y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN mkdir -p $HOME/.vnc && \
    echo '#!/bin/sh\nexec i3' > $HOME/.vnc/xstartup && \
    chmod +x $HOME/.vnc/xstartup

RUN echo -e "vncpass\nvncpass\n" | vncpasswd

EXPOSE 5901

CMD ["sh", "-c", "vncserver :1 && tail -F /dev/null"]
