FROM fedora:latest

RUN dnf -y update && dnf clean all

RUN dnf -y group install "Development Tools" "C Development Tools and Libraries" && dnf clean all

# Install Pupil dependencies
RUN dnf -y install \
	PyOpenGL \
	mesa-libGLU-devel \
	python-setuptools \
	libusb-devel \
	cmake \
	python-zmq \
	python-devel \
	python-pip && dnf clean all

# Set default command
CMD ["/usr/bin/bash"]
