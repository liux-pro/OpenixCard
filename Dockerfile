# 使用官方 Ubuntu 18.04 镜像作为基础镜像
FROM ubuntu:18.04

# 设置环境变量来避免一些交互式安装过程中的提示
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装所需软件包和工具
RUN apt-get update && \
    apt-get install -y \
    wget \
    texinfo \
    git \
    gcc-8 \
    g++-8 \
    build-essential \
    automake \
    autoconf \
    libconfuse-dev \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 设置系统默认值为 gcc-8 和 g++-8
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8

# 下载和构建 binutils
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz && \
    tar xvf binutils-2.38.tar.xz && \
    cd binutils-2.38 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd .. && \
    rm -rf binutils-2.38 binutils-2.38.tar.xz

# 下载和安装 cmake
RUN wget https://cmake.org/files/v3.22/cmake-3.22.1.tar.gz && \
    tar -xzvf cmake-3.22.1.tar.gz && \
    cd cmake-3.22.1 && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf cmake-3.22.1 cmake-3.22.1.tar.gz

# 工作目录设置
WORKDIR /app

# Download the source code
RUN git clone --recursive --depth 1 https://github.com/YuzukiTsuru/OpenixCard
RUN sed -i '$a\target_link_libraries(OpenixCard PRIVATE stdc++fs)' /app/OpenixCard/src/CMakeLists.txt

# Make build directory
RUN mkdir build
WORKDIR /app/build

# Run cmake and make
RUN cmake -DCMAKE_BUILD_TYPE=Release ../OpenixCard && make -j
