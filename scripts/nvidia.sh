#!/bin/bash

# NVIDIA Driver Installation Script for Fedora
# This script installs NVIDIA drivers from negativo17's repository

set -e  # Exit on error

echo "=================================================="
echo "NVIDIA Driver Installation for Fedora"
echo "=================================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
   echo "Please do not run this script as root"
   exit 1
fi

# Detect DNF version
if command -v dnf5 &> /dev/null; then
    DNF="dnf5"
elif command -v dnf &> /dev/null; then
    DNF="dnf"
else
    echo "Error: DNF package manager not found"
    exit 1
fi

echo "Using package manager: $DNF"
echo ""

# Step 1: Add negativo17's repository
echo "Step 1: Adding negativo17's NVIDIA repository..."
sudo $DNF config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo
echo "✓ Repository added successfully"
echo ""

# Step 2: Update system
echo "Step 2: Updating system packages..."
sudo $DNF update --refresh -y
echo "✓ System updated successfully"
echo ""

# Step 3: Install NVIDIA drivers and CUDA
echo "Step 3: Installing NVIDIA drivers, libraries, CUDA, and settings..."
sudo $DNF install -y \
    nvidia-driver \
    nvidia-driver-libs.i686 \
    nvidia-driver-cuda \
    nvidia-settings
echo "✓ NVIDIA drivers installed successfully"
echo ""

echo "=================================================="
echo "Installation complete!"
echo "=================================================="
echo ""
echo "Please reboot your system for the changes to take effect."
echo "After reboot, verify installation with: nvidia-smi"
echo ""
read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi
