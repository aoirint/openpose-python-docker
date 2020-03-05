FROM nvidia/cuda:10.1-cudnn7-devel

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install \
  software-properties-common \
  wget \
  git \
  build-essential \
  protobuf-compiler \
  libprotobuf-dev \
  libhdf5-dev \
  libatlas-base-dev \
  libssl-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev

RUN apt update --fix-missing && apt -y --no-install-recommends install \
  libboost-all-dev

RUN apt update --fix-missing && apt -y install \
  libgoogle-glog-dev \
  libopencv-dev

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && bash -c 'echo -e "\
if command -v pyenv 1>/dev/null 2>&1; then\n\
  eval \"\$(pyenv init -)\"\n\
fi" >> ~/.bashrc'

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

RUN eval "$(pyenv init -)"
RUN pyenv install 3.7.6
RUN pyenv global 3.7.6


WORKDIR /usr/local
RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.0-rc2/cmake-3.17.0-rc2-Linux-x86_64.sh
RUN chmod +x cmake-3.17.0-rc2-Linux-x86_64.sh
RUN bash ./cmake-3.17.0-rc2-Linux-x86_64.sh --skip-license

RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git /openpose
WORKDIR /openpose
RUN git checkout d78ae77fa660fdf75300a5ff1aebab0783052c7b

RUN mkdir /openpose/build
WORKDIR /openpose/build
RUN cmake -DBUILD_PYTHON=true ..

RUN make -j4
RUN make install
RUN ln -s /usr/local/python/openpose/pyopenpose.cpython-36m-x86_64-linux-gnu.so /root/.pyenv/versions/3.7.6/lib/python3.7/site-packages/pyopenpose
RUN ln -s /usr/local/python/openpose/pyopenpose.cpython-36m-x86_64-linux-gnu.so /usr/local/python/openpose/pyopenpose
RUN ln -s /usr/local/python/openpose/pyopenpose.cpython-36m-x86_64-linux-gnu.so /usr/local/python/pyopenpose

RUN echo 'export LD_LIBRARY_PATH="/usr/local/python/openpose:$LD_LIBRARY_PATH"' >> ~/.bashrc

RUN mkdir /code
WORKDIR /code
