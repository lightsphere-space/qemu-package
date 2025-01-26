# Use an official Ubuntu as a base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libtool \
    pkg-config \
    libglib2.0-dev \
    libfdt-dev \
    libpixman-1-dev \
    zlib1g-dev \
    libssl-dev \
    libncurses5-dev \
    libcap-dev \
    libsnappy-dev \
    libsdl2-dev \
    libaio-dev \
    libbluetooth-dev \
    libusb-1.0-0-dev \
    libvirt-dev \
    libspice-server-dev \
    libnfs-dev \
    libudev-dev \
    libpng-dev \
    libjpeg-dev \
    libglib2.0-dev \
    libgpgme11-dev \
    libpciaccess-dev \
    libcapstone-dev \
    libseccomp-dev \
    libzstd-dev \
    libglvnd-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    dpkg-dev \
    fakeroot \
    devscripts \
    debhelper \
    qemu-user-static \
    qemu-system-aarch64 \
    binfmt-support \
    && apt-get clean

# Install additional dependencies for virtual machine emulation
RUN apt-get update && apt-get install -y \
    libvirt-dev \
    libvhost-user-dev \
    libvhost-dev

# Clone QEMU repository
RUN git clone https://gitlab.com/qemu-project/qemu.git /qemu

# Checkout QEMU 9.2.0 version
WORKDIR /qemu
RUN git checkout v9.2.0

# Configure and Build QEMU
RUN ./configure \
    --target-list=aarch64-softmmu \
    --enable-kvm \
    --enable-sdl \
    --enable-vnc \
    --enable-virtio \
    --enable-virtio-vga \
    --enable-virgl \
    --enable-spice \
    && make -j$(nproc)

# Add entrypoint to run QEMU for Raspberry Pi 4 emulation
ENTRYPOINT ["qemu-system-aarch64"]

