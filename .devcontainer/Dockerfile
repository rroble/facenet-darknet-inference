FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive\.ubuntu\.com/mirror.rise.ph/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y python-dev python-setuptools python-pip zenity ninja-build axel git net-tools libopencv-dev cmake