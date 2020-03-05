
## Docker Hub
```sh
docker pull aoirint/openpose-python
```

https://hub.docker.com/r/aoirint/openpose-python

## Build

- Edit `Dockerfile` to match the base image `nvidia/cuda` version with your host cuda.
- Update docker, docker-compose to the latest.
  - docker==19.03.7
  - docker-compose==1.25.4
- Install `nvidia-container-runtime` and setup this (you need to run some setup commands manually).
  - https://github.com/nvidia/nvidia-container-runtime#installation
    - `ls /usr/bin | grep nvidia-container-runtime`
  - https://github.com/nvidia/nvidia-container-runtime#docker-engine-setup
- `sudo docker-compose build`
  - Wait over green tea... some >=500MB files will be downloaded and some builds will run...
