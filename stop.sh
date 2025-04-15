podman container ls |grep vnc |awk '{ print $1 }' |xargs podman stop
