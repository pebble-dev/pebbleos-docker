# Copyright (c) 2025 Core Devices LLC
# SPDX-License-Identifier: Apache-2.0

FROM ubuntu:24.04

ARG EM_VERSION=4.0.7
ARG ARM_GNU_TOOLCHAIN_VERSION=14.2.rel1

ENV EM_VERSION=$EM_VERSION
ENV ARM_GNU_TOOLCHAIN_VERSION=$ARM_GNU_TOOLCHAIN_VERSION

# Set default shell during Docker image build to bash
SHELL ["/bin/bash", "-c"]

# Set non-interactive frontend for apt-get to skip any user confirmations
ENV DEBIAN_FRONTEND=noninteractive

# Install system-level dependencies
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    clang \
    gcc \
    gcc-multilib \
    git \
    gettext \
    python3-dev \
    python3-pip \
    python3-venv \
    xz-utils \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install ARM GNU Toolchain
RUN wget -O arm-gnu-toolchain.tar.xz "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_GNU_TOOLCHAIN_VERSION}/binrel/arm-gnu-toolchain-${ARM_GNU_TOOLCHAIN_VERSION}-${HOSTTYPE}-arm-none-eabi.tar.xz" && \
    tar xf arm-gnu-toolchain.tar.xz -C /opt && \
    rm arm-gnu-toolchain.tar.xz && \
    mv /opt/arm-gnu-toolchain-${ARM_GNU_TOOLCHAIN_VERSION}-${HOSTTYPE}-arm-none-eabi /opt/arm-gnu-toolchain

ENV PATH="/opt/arm-gnu-toolchain/bin:$PATH"

# Install EMSDK
RUN git clone https://github.com/emscripten-core/emsdk.git /opt/emsdk --depth 1 && \
    cd /opt/emsdk && \
    ./emsdk install ${EM_VERSION} && \
    ln -s /opt/emsdk/node/* /opt/emsdk/node/node

ENV PATH="/opt/emsdk:/opt/emsdk/upstream/emscripten:/opt/emsdk/node/node/bin:$PATH"
