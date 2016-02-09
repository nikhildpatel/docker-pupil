FROM fedora:latest

RUN dnf -y update && \
	dnf clean all

RUN dnf -y group install "Development Tools" "C Development Tools and Libraries" && \
	dnf clean all

RUN dnf -y install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm && \
	dnf clean all

# Install Pupil dependencies
RUN dnf -y install \
	PyOpenGL \
	mesa-libGLU-devel \
	libusb-devel \
	cmake \
	python-zmq \
	python-devel \
	ffmpeg \
	ffmpeg-devel \
	opencv-python \
	scipy \
	glew-devel \
	nasm && \
	dnf clean all

# Set default command
CMD ["/usr/bin/bash"]
