FROM nvidia/cuda:10.1-cudnn7-devel

RUN mkdir /code
WORKDIR /code

RUN apt update && apt -y install \
  software-properties-common \
  wget \
  git \
  build-essential \
  protobuf-compiler \
  libprotobuf-dev \
  libhdf5-dev \
  libatlas-base-dev

RUN apt update --fix-missing && apt -y --no-install-recommends install \
  libboost-all-dev

# https://qiita.com/yagince/items/deba267f789604643bab
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update --fix-missing && apt -y install \
  libgoogle-glog-dev \
  libopencv-dev

WORKDIR /usr/local
RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.0-rc2/cmake-3.17.0-rc2-Linux-x86_64.sh
RUN chmod +x cmake-3.17.0-rc2-Linux-x86_64.sh
RUN bash ./cmake-3.17.0-rc2-Linux-x86_64.sh --skip-license

RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git /openpose
RUN git checkout d78ae77fa660fdf75300a5ff1aebab0783052c7b

RUN mkdir /openpose/build
WORKDIR /openpose/build
RUN cmake -DBUILD_PYTHON=true ..

RUN make -j4
RUN make install

WORKDIR /code
