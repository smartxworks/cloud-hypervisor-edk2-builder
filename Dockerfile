FROM ubuntu

WORKDIR /workspace

RUN apt-get update -y && \
    apt-get install -y git ca-certificates make gcc linux-libc-dev m4 bison flex g++ uuid-dev python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
RUN git clone --depth 1 https://github.com/tianocore/edk2.git -b master && \
    cd edk2 && \
    git submodule update --init && \
    cd .. && \
    git clone --depth 1 https://github.com/tianocore/edk2-platforms.git -b master && \
    git clone --depth 1 https://github.com/acpica/acpica.git -b master && \
    export PACKAGES_PATH="$PWD/edk2:$PWD/edk2-platforms" && \
    export IASL_PREFIX="$PWD/acpica/generate/unix/bin/" && \
    make -C acpica && \
    cd edk2/ && \
    . edksetup.sh && \
    cd .. && \
    make -C edk2/BaseTools && \
    build -a AARCH64 -t GCC5 -p ArmVirtPkg/ArmVirtCloudHv.dsc -b RELEASE
