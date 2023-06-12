FROM ubuntu

RUN apt-get update

# TODO: Compile x264 & ffmpeg?
RUN apt-get install -y git build-essential pkg-config autoconf libtool python3.10 python3-pip x264 ffmpeg

RUN mkdir /apps
WORKDIR /apps

RUN git clone https://github.com/sekrit-twc/zimg.git
WORKDIR /apps/zimg
RUN git checkout release-3.0.4
RUN git submodule update --init --recursive
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN make install

RUN pip3 install cython

WORKDIR /apps
RUN git clone https://github.com/vapoursynth/vapoursynth.git
WORKDIR /apps/vapoursynth
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN make install

ENV PYTHONPATH=/usr/local/lib/python3.10/site-packages
ENV LD_LIBRARY_PATH=/usr/local/lib

CMD [ "/bin/bash" ]
