#!/usr/bin/env bash

docker run -it \
	--privileged \
	--env DISPLAY=$DISPLAY \
	--volume /tmp/.X11-unix:/tmp/.X11-unix \
	swilmet/pupil-fedora
