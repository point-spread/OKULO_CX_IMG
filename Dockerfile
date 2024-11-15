FROM ubuntu:20.04 AS build
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.aliyun\.com\/ubuntu/' /etc/apt/sources.list && apt-get update

RUN apt-get install -y cmake make gcc g++ python3 python3-pip wget

ADD opt/gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu.tar.gz  /opt/

ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/opt/gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu/lib/x86_64-linux-gnu/"

RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && pip install --no-cache-dir pycocotools

COPY pip_requirements.txt ./

RUN pip install --no-cache-dir --no-deps -r pip_requirements.txt

RUN wget -c ftp://xj3ftp@vrftp.horizon.ai/ai_toolchain/ai_toolchain.tar.gz --ftp-password=xj3ftp@123$% && tar -xvf ai_toolchain.tar.gz && pip install --no-cache-dir ai_toolchain/h* && rm -r ai_toolchain*

# RUN apt-get install -y software-properties-common && add-apt-repository ppa:rmescandon/yq && apt-get update && apt-get install -y yq 

ARG VERSION=v4.9.6
ARG BINARY=yq_linux_386
RUN wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq \ 
    && chmod +x /usr/bin/yq

RUN pip install --no-cache-dir torch==1.13.0+cpu torchvision==0.14.0+cpu --extra-index-url https://download.pytorch.org/whl/cpu
# RUN pip install --no-cache-dir torch==1.13.0+cpu torchvision==0.14.0+cpu --extra-index-url https://mirror.sjtu.edu.cn/pytorch-wheels/cpu

RUN apt-get install -y --no-install-recommends libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 graphviz

ENV PATH=$PATH:/home/host/tools/

FROM build

COPY lib/psf_packages-0.0.1-py3-none-any.whl ./
RUN pip install --no-cache-dir psf_package*.whl && rm psf_package*
ADD lib/opencv.lib.tar.gz  /usr/lib/opencv
ADD lib/opencv.inc.tar.gz  /usr/include/
ADD dnn_x86_1.18.4a.tar.gz  /usr/lib/
COPY tools /usr/bin

ENV LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/lib/dnn_x86/lib/:/usr/lib/opencv/lib"

WORKDIR /home/host/