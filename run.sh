#!/bin/bash
mkdir -p /home/$USER/renode_workspace
xhost +local:*

docker run -it --rm \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
           -v /home/$USER/renode_workspace:/workspace \
           --network host \
           --name renode_tf \
            renode_tf bash