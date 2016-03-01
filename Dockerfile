FROM fedora:latest
MAINTAINER Sébastien Wilmet

RUN dnf -y update && \
	dnf -y group install \
		"Development Tools" \
		"C Development Tools and Libraries" \
		"Basic Desktop" && \
	dnf -y install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm && \
	dnf -y update && \
	dnf -y install \
		PyOpenGL \
		mesa-libGLU-devel \
		libusb-devel \
		cmake \
		python-zmq \
		python-devel \
		ffmpeg \
		ffmpeg-devel \
		opencv-python \
		opencv-devel \
		scipy \
		glew-devel \
		nasm \
		redhat-rpm-config \
		glfw-devel \
		eigen3-devel \
		ceres-solver-devel \
		boost-devel \
		glog-devel \
		gflags-devel && \
	dnf clean all

# Install libjpeg-turbo from sources to use the --with-pic flag.
RUN cd /root/ && \
	curl -o libjpeg-turbo.tar.gz -L "http://sourceforge.net/projects/libjpeg-turbo/files/1.4.2/libjpeg-turbo-1.4.2.tar.gz/download" && \
	tar xf libjpeg-turbo.tar.gz && \
	cd libjpeg-turbo-1.4.2 && \
	./configure --with-pic && \
	make install

# Install libuvc from git.
RUN cd /root/ && \
	commit="900435183778f4a94a4197214166392e74e7edad" && \
	curl -o libuvc.tar.gz -L "https://github.com/pupil-labs/libuvc/archive/${commit}.tar.gz" && \
	tar xf libuvc.tar.gz && \
	cd libuvc-${commit} && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install

# Workaround for libuvc cmake shenanigan.
RUN echo "/usr/local/lib" >> /etc/ld.so.conf && \
	ldconfig

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
	commit="731082a861a7688ce182c37917541cf3e320e1b9" && \
	curl -o PyAV.tar.gz -L "https://github.com/pupil-labs/PyAV/archive/${commit}.tar.gz" && \
	tar xf PyAV.tar.gz && \
	cd PyAV-${commit} && \
	python setup.py install

# Install pyuvc.
RUN cd /root/ && \
	version="0.5" && \
	curl -o pyuvc.tar.gz -L "https://github.com/pupil-labs/pyuvc/archive/v${version}.tar.gz" && \
	tar xf pyuvc.tar.gz && \
	cd pyuvc-${version} && \
	python setup.py install

# Install pyglui.
# It doesn't work from the tarball because there are some git submodules. So do a git clone instead.
RUN cd /root/ && \
	version="0.8" && \
	git clone http://github.com/pupil-labs/pyglui && \
	cd pyglui && \
	git checkout -b docker v${version} && \
	git submodule update --init --recursive && \
	python setup.py install

# Download pupil source code.
RUN cd /root/ && \
	commit="9c1386a571f853bc6774c7e17e17b7c0c26ca826" && \
	git clone https://github.com/pupil-labs/pupil && \
	cd pupil && \
	git checkout -b docker ${commit}

WORKDIR /root/pupil/

# Set default command
CMD ["/usr/bin/bash"]
