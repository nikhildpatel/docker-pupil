#!/usr/bin/env bash

# Normally a container offers greater security, but it is not the case if you
# run the container with this script, since the privileged mode and net=host
# are used. So you need to trust the software installed inside the container.
# But a container offers other advantages, as explained in the README.md file.
#
# However, it should be entirely feasible to have a more confined container:
# - Instead of --privileged, provide a list of --device (but it's maybe not
#   sufficient).
# - Instead of --net=host, --publish a port.
#
# Rationale for the options:
# - privileged: to be able to access the webcam devices, the graphics card
#   device, etc.
# - net=host: to configure more easily the IP address and port of the Pupil
#   Broadcast Server.
# - DISPLAY and X11 socket volume: needed for a GUI application.

docker run -it \
	--privileged \
	--net=host \
	--env DISPLAY=$DISPLAY \
	--volume /tmp/.X11-unix:/tmp/.X11-unix \
	--volume ~/pupil-recordings:/root/pupil/recordings \
	swilmet/pupil-fedora
