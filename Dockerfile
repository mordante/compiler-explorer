FROM ubuntu:23.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
		git \
		lsb-release \
		nodejs \
		npm \
		software-properties-common \
		vim \
		wget \
	&& apt-get autoremove --purge -y \
	&& apt-get autoclean -y \
	&& rm -rf /var/cache/apt/* /tmp/*

RUN git clone  --depth 1 https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer
RUN cd /compiler-explorer && make prebuild

# Disables automatically compilation by default
RUN sed -i -e "s/ompileOnChange', true/ompileOnChange', false/" /compiler-explorer/static/settings.ts
ADD cpp.properties /compiler-explorer/etc/config/c++.local.properties
ADD default.cpp /compiler-explorer/examples/c++

ENV GCC_LATEST_VERSION=13
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt install -y \
		gcc-$((GCC_LATEST_VERSION - 1)) \
		g++-$((GCC_LATEST_VERSION - 1)) \
		gcc-$GCC_LATEST_VERSION \
		g++-$GCC_LATEST_VERSION \
	&& apt-get autoremove --purge -y \
	&& apt-get autoclean -y \
	&& rm -rf /var/cache/apt/* /tmp/*

ENV LLVM_HEAD_VERSION=17
RUN wget https://apt.llvm.org/llvm.sh -O /tmp/llvm.sh
RUN bash /tmp/llvm.sh $(($LLVM_HEAD_VERSION - 1))
RUN bash /tmp/llvm.sh $LLVM_HEAD_VERSION
RUN apt-get update && apt-get install -y \
		libc++-$LLVM_HEAD_VERSION-dev \
		libc++abi-$LLVM_HEAD_VERSION-dev \
		libunwind-$LLVM_HEAD_VERSION-dev \
	&& apt-get autoremove --purge -y \
	&& apt-get autoclean -y \
	&& rm -rf /var/cache/apt/* /tmp/*

EXPOSE 10240
WORKDIR /compiler-explorer
ENTRYPOINT [ "make" ]
