podman build -t vncarch .

podman run --rm -it \
    --privileged \
    --net=host \
    -v ~/dev:/home/vncuser/dev \
    -v $(pwd)/local:/home/vncuser/.local \
    -v $(pwd)/config:/home/vncuser/.config \
    -v $(pwd)/mozilla:/home/vncuser/.mozilla \
    vncarch
