FROM fedora:latest

RUN dnf -y update && \
	dnf clean all

RUN dnf -y group install "Development Tools" "C Development Tools and Libraries" && \
	dnf clean all

RUN dnf -y install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm && \
	dnf clean all

# Install the Pupil dependencies available in the distro.
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
	nasm \
	redhat-rpm-config && \
	dnf clean all

# Install libjpeg-turbo from sources to use the --with-pic flag.
RUN cd /root/ && \
	curl -o libjpeg-turbo.tar.gz -L "http://sourceforge.net/projects/libjpeg-turbo/files/1.4.2/libjpeg-turbo-1.4.2.tar.gz/download" && \
	tar xf libjpeg-turbo.tar.gz && \
	cd libjpeg-turbo-1.4.2 && \
	./configure --with-pic && \
	make install && \
	cd -

# Install libuvc from git.
RUN cd /root/ && \
	git clone https://github.com/pupil-labs/libuvc && \
	cd libuvc && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install && \
	cd -

# Install some Python packages.
RUN pip install --upgrade pip

RUN pip install \
	numexpr \
	cython \
	psutil \
	pyzmq \
	https://github.com/zeromq/pyre/archive/master.zip

# Install PyAV.
RUN cd /root/ && \
	git clone https://github.com/pupil-labs/PyAV && \
	cd PyAV && \
	python setup.py install && \
	cd -

# Install GLFW.
RUN dnf -y install glfw-devel

# Set default command
CMD ["/usr/bin/bash"]
