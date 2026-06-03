# build using the following:
# docker build -t os-dev-env:v1 .
#
# Run with:
# docker run --rm -it -v "$(pwd)":/workspace os-dev-env:v1 /bin/bash

# Use the official stable Ubuntu image
FROM ubuntu:24.04

# Prevent interactive configuration prompts during apt installation
ENV DEBIAN_FRONTEND=noninteractive

# Install native build utilities alongside the explicit i686 cross-compiler
RUN apt-get update && apt-get install -y \
    build-essential \
    nasm \
    gcc-i686-linux-gnu \
    g++-i686-linux-gnu \
    make \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the active working directory inside the container
WORKDIR /workspace
