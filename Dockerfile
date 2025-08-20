FROM ubuntu:24.04

# install dependencies from apt
RUN apt update && apt install -y \
    build-essential cmake pkg-config  \
    rtl-sdr libsoapysdr-dev soapysdr-tools soapysdr-module-rtlsdr \
    git wget ca-certificates libssl-dev nginx

# create a directory structure for habdec & stuff
RUN mkdir /habdec
RUN mkdir /habdec/habdec

# compile boost 1.68
RUN cd /habdec && \
	wget https://archives.boost.io/release/1.68.0/source/boost_1_68_0.tar.gz && \
	tar -xf ./boost_1_68_0.tar.gz && \
	cd boost_1_68_0 && \
	./bootstrap.sh && \
	./b2 -j 4 --layout=tagged --build-type=complete stage
	
# compile fftw 3.3.8
RUN cd /habdec && \
	wget http://fftw.org/fftw-3.3.8.tar.gz && \
	tar -xf ./fftw-3.3.8.tar.gz && \
	cd fftw-3.3.8 && \
	./configure --with-slow-timer --enable-single CFLAGS="-O4 -pipe -march=native -Wall" --prefix=`pwd`/install && \
	make && \
	make install
	
# compile HABDEC
COPY . /habdec/habdec
RUN cd /habdec/habdec && \
	#git clone --recurse-submodules https://github.com/oktkas/habdec.git && \
	git submodule update --init --recursive && \
	mkdir build && \
	cd build && \
	cmake -D BOOST_ROOT=/habdec/boost_1_68_0/ -D FFTW_ROOT=/habdec/fftw-3.3.8/install -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=Off ../code && \
	make -j 4 && \
	make install

# RUN HABDEC
EXPOSE 5555
CMD /habdec/habdec/build/install/habdecWebsocketServer device 0 sampling_rate 2.024e6
#CMD /habdec/habdec/build/install/habdecWebsocketServer device $DEVICE sampling_rate $SAMPLING_RATE rtty $RTTY_OPTS print $PRINT freq $FREQ gain $GAIN biast $BIAST afc $AFC station $STATION latlon $LATLON
