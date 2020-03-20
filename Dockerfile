FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04


#install python
RUN apt update && apt install -y git htop curl wget unzip gzip unrar python-dev python3.7 python3-pip python3-dev python3.7-dev build-essential cmake
RUN python3.7 -m pip install pip
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3.7 /usr/bin/python
RUN python -m pip install --upgrade pip

#install pytorch
RUN pip install torch torchvision torchtext numpy tensorboardX>=1.9 tqdm scipy scikit-learn pandas

# install apex
WORKDIR /tmp/unique_for_apex
RUN SHA=ToUcHMe git clone https://github.com/NVIDIA/apex.git
WORKDIR /tmp/unique_for_apex/apex
RUN pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" .
WORKDIR /workspace

# install nvtop
RUN ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/stubs/libnvidia-ml.so /usr/local/lib/libnvidia-ml.so
RUN ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/stubs/libnvidia-ml.so /usr/local/lib/libnvidia-ml.so.1

RUN apt-get update && \
    apt-get install -y cmake libncurses5-dev libncursesw5-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /work/*

RUN cd /tmp && \
    git clone https://github.com/Syllo/nvtop.git && \
    mkdir -p nvtop/build && cd nvtop/build && \
    cmake .. -DNVML_RETRIEVE_HEADER_ONLINE=True && \
    make && \ 
    make install && \
    cd / && \
    rm -r /tmp/nvtop
RUN rm /usr/local/lib/libnvidia-ml.so
RUN rm /usr/local/lib/libnvidia-ml.so.1
