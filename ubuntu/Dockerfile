FROM ubuntu:20.04
LABEL maintainer "ekffu200098@gmail.com"

# Setup
ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Asia/Seoul"

RUN apt-get update && apt-get -y install sudo tzdata
RUN adduser --disabled-password --gecos "" user \
    && echo "user:user" | chpasswd \
    && adduser user sudo \
    && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
WORKDIR /home/user

# Source
COPY executor.sh .
