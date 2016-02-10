docker-pupil
============

Fedora dockerfile for [Pupil](https://pupil-labs.com/).

To build:

Copy the sources down and do the build:

    # docker build --rm --tag <username>/pupil-fedora .

To run:

    # docker run -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix <username>/pupil-fedora
