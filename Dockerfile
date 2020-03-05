FROM nvidia/cuda:10.1-cudnn7-devel

RUN mkdir /code
WORKDIR /code

RUN apt update && apt -y install \
  software-properties-common \
  git \
  build-essential \
  cmake \
#   protobuf-compiler \
  libprotobuf-dev

RUN apt update --fix-missing && apt -y --no-install-recommends install \
  libboost-all-dev

# https://qiita.com/yagince/items/deba267f789604643bab
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update --fix-missing && apt -y install \
  libgoogle-glog-dev \
  libopencv-dev

RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git /openpose

RUN mkdir /openpose/build
WORKDIR /openpose/build
RUN cmake -DBUILD_PYTHON=true ..

WORKDIR /code
