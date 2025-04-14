docker container ls |grep vnc |awk '{ print $1 }' |xargs docker stop
