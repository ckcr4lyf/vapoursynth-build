FROM ubuntu

RUN apt-get update

# TODO: Compile x264 & ffmpeg?
RUN apt-get install -y git cmake ninja-build build-essential pkg-config autoconf libtool python3.10 python3-pip x264 ffmpeg libavformat-dev libavcodec-dev libswscale-dev libavutil-dev libswresample-dev libpng-dev

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
RUN mkdir /usr/local/lib/vapoursynth
RUN ln -s /usr/local/lib/libffms2.so /usr/local/lib/vapoursynth/libffms2.so

WORKDIR /apps
RUN git clone https://github.com/ImageMagick/ImageMagick.git
WORKDIR /apps/ImageMagick
RUN git checkout 7.1.1-11
RUN ./configure --enable-hdri --with-png
RUN make -j$(nproc)
RUN make install

RUN pip3 install meson

WORKDIR /apps
RUN git clone https://github.com/vapoursynth/vs-imwri.git
WORKDIR /apps/vs-imwri
RUN git checkout R2
RUN meson build
RUN ninja -C build
RUN ln -s /apps/vs-imwri/build/libimwri.so /usr/local/lib/vapoursynth/libimwri.so

WORKDIR /

CMD [ "/bin/bash" ]
