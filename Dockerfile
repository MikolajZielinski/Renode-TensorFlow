FROM ubuntu:20.04

# Create working directory
RUN mkdir workspace

# Install dependencies
RUN apt update -y && apt upgrade -y
RUN apt install -y wget unzip
RUN apt install -y git automake autoconf libtool g++ coreutils policykit-1 libgtk2.0-dev uml-utilities gtk-sharp2 python3 python3-pip
RUN apt install -y libasound2 libsecret-1-dev libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev kmod

# Install Arduino IDE
RUN wget https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.2_Linux_64bit.zip
RUN unzip arduino-ide_2.3.2_Linux_64bit.zip
RUN rm arduino-ide_2.3.2_Linux_64bit.zip

RUN echo 'export PATH=$PATH:/arduino-ide_2.3.2_Linux_64bit' >> ~/.bashrc 

# Install TensorFlowLite
RUN mkdir -p /root/Arduino/libraries
WORKDIR /root/Arduino/libraries
RUN git clone https://github.com/tensorflow/tflite-micro-arduino-examples Arduino_TensorFlowLite

# TensorFlow Renode Serial Monitor patch
RUN sed -i'' '/#define DEBUG_SERIAL_OBJECT/s/(Serial)/(Serial1)/' /root/Arduino/libraries/Arduino_TensorFlowLite/src/tensorflow/lite/micro/system_setup.cpp

# Install Renode
WORKDIR /
RUN git clone https://github.com/renode/renode.git
RUN cd renode
WORKDIR /renode
RUN python3 -m pip install -r tests/requirements.txt
RUN ./build.sh

RUN echo 'export PATH=$PATH:/renode' >> ~/.bashrc 

# Setup working directory
RUN cd /workspace
WORKDIR /workspace