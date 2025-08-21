# ---------- Stage 1: Builder ---------- #
FROM ubuntu:24.04 AS builder

ENV DEVICE=""
ENV SAMPLING_RATE=""
ENV NO_EXIT=""
ENV PORT="0.0.0.0:5555"
ENV STATION=""
ENV LATLON=""
ENV ALT=""
ENV FREQ=""
ENV PPM=""
ENV GAIN=""
ENV PRINT=""
ENV RTTY=""
ENV BIAST=""
ENV BIAS_T=""
ENV AFC=""
ENV USB_PACK=""
ENV DC_REMOVE=""
ENV DEC=""
ENV LOWPASS=""
ENV LP_TRANS=""
ENV SENTENCE_CMD=""
ENV SONDEHUB=""

# Install build dependencies
RUN apt update && apt install -y --no-install-recommends \
    build-essential cmake pkg-config \
    rtl-sdr libsoapysdr-dev soapysdr-tools soapysdr-module-rtlsdr \
    git wget ca-certificates libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /habdec/habdec

# Compile Boost 1.68
RUN cd /habdec && \
    wget https://archives.boost.io/release/1.68.0/source/boost_1_68_0.tar.gz && \
    tar -xf ./boost_1_68_0.tar.gz && rm ./boost_1_68_0.tar.gz && \
    cd boost_1_68_0 && ./bootstrap.sh && ./b2 -j$(nproc) --layout=tagged --build-type=complete stage

# Compile FFTW 3.3.8
RUN cd /habdec && \
    wget http://fftw.org/fftw-3.3.8.tar.gz && \
    tar -xf ./fftw-3.3.8.tar.gz && rm ./fftw-3.3.8.tar.gz && \
    cd fftw-3.3.8 && \
    ./configure --with-slow-timer --enable-single CFLAGS="-O4 -pipe -march=native -Wall" --prefix=`pwd`/install && \
    make -j$(nproc) && make install

# Compile HABDEC
COPY . /habdec/habdec
RUN cd /habdec/habdec && \
    git submodule update --init --recursive && \
    mkdir build && cd build && \
    cmake -D BOOST_ROOT=/habdec/boost_1_68_0/ \
          -D FFTW_ROOT=/habdec/fftw-3.3.8/install \
          -DCMAKE_BUILD_TYPE=Release \
          -DBUILD_SHARED_LIBS=Off ../code && \
    make -j$(nproc) && make install && \
    strip /habdec/habdec/build/install/habdecWebsocketServer

# ---------- Stage 2: Runtime ---------- #
FROM ubuntu:24.04

# Copy compiled HABDEC
COPY --from=builder /habdec/habdec/build/install /habdec/habdec/build/install

# Set ENV variables
ENV DEVICE=""
ENV SAMPLING_RATE=""
ENV NO_EXIT=""
ENV PORT="0.0.0.0:5555"
ENV STATION=""
ENV LATLON=""
ENV ALT=""
ENV FREQ=""
ENV PPM=""
ENV GAIN=""
ENV PRINT=""
ENV RTTY=""
ENV BIAST=""
ENV BIAS_T=""
ENV AFC=""
ENV USB_PACK=""
ENV DC_REMOVE=""
ENV DEC=""
ENV LOWPASS=""
ENV LP_TRANS=""
ENV SENTENCE_CMD=""
ENV SONDEHUB=""

# Runtime dependencies only
RUN apt update && apt install -y --no-install-recommends \
    rtl-sdr libsoapysdr-dev soapysdr-tools soapysdr-module-rtlsdr \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5555

# Run HABDEC with CLI parameters
CMD ["sh", "-c", "/habdec/habdec/build/install/habdecWebsocketServer \
  --device $DEVICE \
  --sampling_rate $SAMPLING_RATE \
  --no_exit $NO_EXIT \
  --port $PORT \
  --station $STATION \
  --latlon $LATLON \
  --alt $ALT \
  --freq $FREQ \
  --ppm $PPM \
  --gain $GAIN \
  --print $PRINT \
  --rtty $RTTY \
  --biast $BIAST \
  --bias_t $BIAS_T \
  --afc $AFC \
  --usb_pack $USB_PACK \
  --dc_remove $DC_REMOVE \
  --dec $DEC \
  --lowpass $LOWPASS \
  --lp_trans $LP_TRANS \
  --sentence_cmd $SENTENCE_CMD \
  --sondehub $SONDEHUB"]
