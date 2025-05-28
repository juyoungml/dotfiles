#!/bin/bash

# NVIDIA GPU configuration and driver installation script

echo "NVIDIA GPU Configuration Script"
echo "==============================="

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "This script is designed for Linux systems only."
    exit 1
fi

# Function to detect GPU
detect_gpu() {
    if command -v lspci &> /dev/null; then
        GPU_INFO=$(lspci | grep -i nvidia)
        if [ -n "$GPU_INFO" ]; then
            echo "NVIDIA GPU detected: $GPU_INFO"
            return 0
        else
            echo "No NVIDIA GPU detected."
            return 1
        fi
    else
        echo "lspci not available. Install pciutils: sudo apt install pciutils"
        return 1
    fi
}

# Function to install NVIDIA drivers
install_drivers() {
    echo "Installing NVIDIA drivers..."
    
    # Update package list
    sudo apt update
    
    # Install recommended driver
    sudo apt install -y ubuntu-drivers-common
    sudo ubuntu-drivers autoinstall
    
    # Alternative method with specific driver
    # sudo apt install -y nvidia-driver-535 nvidia-dkms-535
}

# Function to install CUDA
install_cuda() {
    echo "Installing CUDA toolkit..."
    
    # Add NVIDIA package repository
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
    sudo dpkg -i cuda-keyring_1.0-1_all.deb
    sudo apt update
    
    # Install CUDA
    sudo apt install -y cuda-toolkit-12-2
    
    # Add CUDA to PATH
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
    
    # Clean up
    rm cuda-keyring_1.0-1_all.deb
}

# Function to install cuDNN
install_cudnn() {
    echo "Installing cuDNN..."
    echo "Note: cuDNN requires manual download from NVIDIA website"
    echo "1. Go to https://developer.nvidia.com/cudnn"
    echo "2. Download cuDNN for your CUDA version"
    echo "3. Extract and copy files to CUDA installation directory"
    echo "4. Run this script with 'cudnn' parameter after manual download"
}

# Function to install Docker with NVIDIA support
install_docker_nvidia() {
    echo "Installing Docker with NVIDIA runtime support..."
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    
    # Install NVIDIA Container Toolkit
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    
    sudo apt update && sudo apt install -y nvidia-docker2
    sudo systemctl restart docker
    
    # Clean up
    rm get-docker.sh
}

# Function to verify installation
verify_installation() {
    echo "Verifying NVIDIA installation..."
    
    # Check driver
    if command -v nvidia-smi &> /dev/null; then
        echo "✓ NVIDIA driver installed successfully"
        nvidia-smi
    else
        echo "✗ NVIDIA driver not found"
    fi
    
    # Check CUDA
    if command -v nvcc &> /dev/null; then
        echo "✓ CUDA installed successfully"
        nvcc --version
    else
        echo "✗ CUDA not found"
    fi
    
    # Check Docker NVIDIA support
    if command -v docker &> /dev/null; then
        if docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi 2>/dev/null; then
            echo "✓ Docker NVIDIA support working"
        else
            echo "✗ Docker NVIDIA support not working"
        fi
    fi
}

# Main script logic
case "${1:-all}" in
    "detect")
        detect_gpu
        ;;
    "drivers")
        detect_gpu && install_drivers
        ;;
    "cuda")
        install_cuda
        ;;
    "cudnn")
        install_cudnn
        ;;
    "docker")
        install_docker_nvidia
        ;;
    "verify")
        verify_installation
        ;;
    "all")
        detect_gpu || exit 1
        install_drivers
        install_cuda
        install_docker_nvidia
        echo "Installation complete. Please reboot your system."
        echo "After reboot, run: ./install_nvidia.sh verify"
        ;;
    *)
        echo "Usage: $0 [detect|drivers|cuda|cudnn|docker|verify|all]"
        echo "  detect  - Detect NVIDIA GPU"
        echo "  drivers - Install NVIDIA drivers"
        echo "  cuda    - Install CUDA toolkit"
        echo "  cudnn   - Instructions for cuDNN installation"
        echo "  docker  - Install Docker with NVIDIA support"
        echo "  verify  - Verify installation"
        echo "  all     - Install everything (default)"
        exit 1
        ;;
esac