FROM ubuntu:20.04

# Create working directory
RUN mkdir workspace

# Install dependencies
RUN apt update -y && apt upgrade -y
RUN apt install -y git automake autoconf libtool g++ coreutils policykit-1 libgtk2.0-dev uml-utilities gtk-sharp2 python3 python3-pip

# Install Renode
RUN git clone https://github.com/renode/renode.git
RUN cd renode
WORKDIR /renode
RUN python3 -m pip install -r tests/requirements.txt
RUN ./build.sh

RUN echo 'export PATH=$PATH:/renode' >> ~/.bashrc 

# Setup working directory
RUN cd /workspace
WORKDIR /workspace

