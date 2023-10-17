FROM ubuntu:jammy

RUN apt-get update && apt-get upgrade -y \
    && apt-get install apt-utils -y

RUN apt-get install git -y
RUN apt-get install libc6-dev -y

ENV USER=mcpe
ENV HOME=/home/mcpe

RUN apt install --no-install-recommends -y ca-certificates \
    apt-transport-https \
    sudo curl make gcc wget \
    autoconf automake m4 \
    bzip2 bison g++ cmake pkg-config \
    re2c libtool-bin screen mc nano \
    xz-utils

RUN useradd -d ${HOME} -m ${USER} && passwd -d ${USER} && adduser ${USER} sudo

WORKDIR /home/mcpe/

RUN mkdir pm5
RUN mkdir pm4

CMD ["/bin/sh"]
