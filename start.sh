docker buildx build -t vncarch .

docker run --rm -it \
    --net=host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/dev:/home/vncuser/dev \
    -v $(pwd)/local:/home/vncuser/.local \
    -v $(pwd)/config:/home/vncuser/.config \
    vncarch
