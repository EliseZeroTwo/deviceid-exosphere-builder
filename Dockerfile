ARG DEBIAN_FRONTEND=noninteractive
ARG DEVKITPRO_URL=https://github.com/devkitPro/pacman/releases/download/v1.0.2/
ARG DEVKITPRO_FILE=devkitpro-pacman.amd64.deb
ARG ATMOSPHERE_TAG=0.14.1

FROM ubuntu:focal

ARG DEBIAN_FRONTEND
ARG DEVKITPRO_URL
ARG DEVKITPRO_FILE
ARG ATMOSPHERE_TAG

# Install base libs
RUN apt update && \
    apt install -y \
    wget \
    git \
    build-essential \
    libxml2 \
    libxml2-dev \
    libxml2-utils \
    zip \
    curl \
    libarchive13 \
    pkg-config \
    libglm-dev \
    python3 \
    python3-pip

RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN pip3 install pycryptodome lz4

# Get and install devkitPro and install required libs
WORKDIR /
RUN wget $DEVKITPRO_URL$DEVKITPRO_FILE
RUN dpkg -i $DEVKITPRO_FILE
RUN dkp-pacman -S --noconfirm switch-dev switch-libjpeg-turbo devkitARM devkitarm-rules
RUN rm $DEVKITPRO_FILE
ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=/opt/devkitpro/devkitARM 

# Get and prebuild parts of Atmosphere
RUN git clone https://github.com/Atmosphere-NX/Atmosphere
WORKDIR /Atmosphere
RUN git checkout $ATMOSPHERE_TAG
RUN git switch -c deviceid-exosphere
WORKDIR /Atmosphere/exosphere
RUN make -j$(nproc) exosphere.bin

ADD build-deviceid-exosphere.sh .

ENTRYPOINT [ "/Atmosphere/exosphere/build-deviceid-exosphere.sh" ]