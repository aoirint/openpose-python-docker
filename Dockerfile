FROM nvidia/cuda:10.1-cudnn7-devel

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt update --fix-missing && apt -y --no-install-recommends install \
  software-properties-common \
  wget \
  git \
  build-essential \
  protobuf-compiler \
  libprotobuf-dev \
  libhdf5-dev \
  libatlas-base-dev \
  libboost-all-dev \
  libgoogle-glog-dev \
  libopencv-dev \
  python3 \
  python3-pip

WORKDIR /usr/local
RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.0-rc2/cmake-3.17.0-rc2-Linux-x86_64.sh \
    && chmod +x cmake-3.17.0-rc2-Linux-x86_64.sh \
    && bash ./cmake-3.17.0-rc2-Linux-x86_64.sh --skip-license

RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git /openpose \
    && cd /openpose \
    && git checkout d78ae77fa660fdf75300a5ff1aebab0783052c7b

RUN mkdir /openpose/build \
    && cd /openpose/build \
    && cmake -DBUILD_PYTHON=true .. \
    && make -j4 \
    && make install

RUN pip3 install \
  numpy \
  opencv-python
