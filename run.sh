#!/usr/bin/env bash

docker run -it \
	--env DISPLAY=$DISPLAY \
	--volume /tmp/.X11-unix:/tmp/.X11-unix \
	swilmet/pupil-fedora
