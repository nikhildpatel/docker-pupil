FROM fedora:latest

RUN dnf -y update && \
	dnf -y group install "Development Tools" "C Development Tools and Libraries" && \
	dnf -y install --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm && \
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
	git clone https://github.com/pupil-labs/libuvc && \
	cd libuvc && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install

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

# Set default command
CMD ["/usr/bin/bash"]
