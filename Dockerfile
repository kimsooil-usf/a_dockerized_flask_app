#FROM python:3.9.1
#ADD . /python-flask
#WORKDIR /python-flask
#RUN pip install -r requirements.txt

FROM ubuntu:18.04

# Install the MCR dependencies and some things we'll need and download the MCR
# from Mathworks -silently install it
RUN apt-get -qq update && apt-get -qq install -y \
    unzip \
    xorg \
    wget \
    curl
RUN apt-get update && apt-get install -y software-properties-common gcc
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install python3.8 -y
RUN apt-get update && \
    apt-get install python3-pip -y
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3.8 /usr/bin/python

RUN mkdir /mcr-install && \
    mkdir /opt/mcr && \
    cd /mcr-install && \
    wget https://ssd.mathworks.com/supportfiles/downloads/R2021a/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2021a_Update_5_glnxa64.zip && \
    cd /mcr-install && \
    unzip -q MATLAB_Runtime_R2021a_Update_5_glnxa64.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    rm -rf mcr-install

# Configure environment variables for MCR
ENV LD_LIBRARY_PATH /opt/mcr/v910/runtime/glnxa64:/opt/mcr/v910/bin/glnxa64:/opt/mcr/v910/sys/os/glnxa64:/opt/mcr/v97/extern/bin/glnxa64LD_LIBRARY_PATH /opt/mcr/v910/runtime/glnxa64:/opt/mcr/v910/bin/glnxa64:/opt/mcr/v910/sys/os/glnxa64

#COPY requirements.txt /python-flask
WORKDIR /python-flask
ADD . /python-flask
RUN pip install Flask
#RUN pip install -r requirements.txt