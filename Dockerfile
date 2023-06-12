FROM ubuntu

RUN apt-get update

# TODO: Compile x264 & ffmpeg?
RUN apt-get install -y git build-essential pkg-config autoconf libtool python3.10 python3-pip x264 ffmpeg libavformat-dev libavcodec-dev libswscale-dev libavutil-dev libswresample-dev

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
RUN git checkout R62
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN make install

ENV PYTHONPATH=/usr/local/lib/python3.10/site-packages
ENV LD_LIBRARY_PATH=/usr/local/lib

RUN pip3 install awsmfunc

WORKDIR /apps
RUN git clone https://github.com/FFMS/ffms2.git
WORKDIR /apps/ffms2
RUN git checkout 2.40
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN make install

CMD [ "/bin/bash" ]
