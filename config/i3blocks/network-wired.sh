#!/bin/bash
IFACE=$(ip link | awk '/enp|eth/{gsub(/:/,""); print $2; exit}')
[[ -z $IFACE ]] && echo "down" && exit 33

IP=$(ip addr show $IFACE | awk '/inet /{print $2}' | cut -d/ -f1)
[[ -n $IP ]] && echo "${IP}" || echo "down"
