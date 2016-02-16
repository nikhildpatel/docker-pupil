FROM fedora:latest

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
		scipy \
		glew-devel \
		nasm \
		redhat-rpm-config \
		glfw-devel \
		ceres-solver && \
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
	commit="f17ba66296aa7fc7e1ccb91be239a7fcc8d238ea" && \
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
	git clone http://github.com/pupil-labs/pyuvc && \
	cd pyuvc && \
	python setup.py install

# Install pyglui.
RUN cd /root/ && \
	git clone http://github.com/pupil-labs/pyglui --recursive && \
	cd pyglui && \
	python setup.py install

# Download pupil source code.
RUN cd /root/ && \
	git clone https://github.com/pupil-labs/pupil

RUN dnf -y install \
	opencv-devel \
	eigen3-devel \
	ceres-solver-devel \
	boost-devel && \
	dnf clean all

# Set default command
CMD ["/usr/bin/bash"]
