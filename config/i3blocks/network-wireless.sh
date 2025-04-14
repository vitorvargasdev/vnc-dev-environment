#!/bin/bash
IFACE=$(ip link | awk '/wl/{gsub(/:/,""); print $2; exit}')
[[ -z $IFACE ]] && echo "down" && exit 33  # 33 = i3blocks error color

ESSID=$(iwgetid -r)
QUALITY=$(iwconfig $IFACE | awk -F'[ =]' '/Quality/{print $3}')
IP=$(ip addr show $IFACE | awk '/inet /{print $2}' | cut -d/ -f1)

[[ -n $IP ]] && echo "(${QUALITY} at ${ESSID}) ${IP}" || echo "down"
