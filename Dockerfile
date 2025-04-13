FROM archlinux:latest

RUN pacman -Sy --noconfirm archlinux-keyring
RUN pacman-key --init && pacman-key --populate

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm tigervnc firefox xorg-server dbus sudo neovim
RUN pacman -S --noconfirm i3-wm rofi i3status networkmanager network-manager-applet tilix

RUN pacman -S --noconfirm libxslt

RUN useradd -m -G wheel -s /bin/bash vncuser
RUN echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN echo "vncuser:vncpass" | chpasswd

USER vncuser
ENV HOME /home/vncuser
COPY ./i3 /home/vncuser/.config/i3
WORKDIR /home/vncuser

RUN mkdir -p $HOME/.vnc

RUN echo '#!/bin/sh\nexec i3' > $HOME/.vnc/xstartup && \
    chmod +x $HOME/.vnc/xstartup

RUN echo -e "vncpass\nvncpass\n" | vncpasswd

EXPOSE 5901

CMD ["sh", "-c", "vncserver :1 && tail -F /dev/null"]
