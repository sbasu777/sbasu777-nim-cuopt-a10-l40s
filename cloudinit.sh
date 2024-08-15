#!/usr/bin/env bash

# Function to log messages
log() {
  echo "$(date +"%Y-%m-%d %T") - $1"
}

# Function to broadcast messages
broadcast() {
  echo "$1" | wall
}

# Broadcast and log start of installation
broadcast "Starting installation of nvidia-container-toolkit and cuopt..."
log "Starting installation of nvidia-container-toolkit and cuopt..."

# Get API key from Terraform variable
api_key="${nvidia_api_key}"

# Install nvidia-container-toolkit
broadcast "Installing nvidia-container-toolkit..."
log "Installing nvidia-container-toolkit..."
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo >/dev/null
sudo yum install -y nvidia-container-toolkit >/dev/null
broadcast "nvidia-container-toolkit installed successfully."
log "nvidia-container-toolkit installed successfully."

# Generate CDI configuration for podman
broadcast "Configuring CDI to use with podman..."
log "Configuring CDI to use with podman..."
sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml >/dev/null
broadcast "CDI configured successfully."
log "CDI configured successfully."

# Setup nvidia driver to be persistent across reboots
broadcast "Running nvidia-persistented..."
log "Running nvidia-persistented..."
nvidia-persistenced # this will make /dev/nvidia0
systemctl enable nvidia-persistenced
broadcast "nvidia-persistented running and enabled."
log "nvidia-persistented running and enabled."

# Install podman
broadcast "Installing podman..."
log "Installing podman..."
sudo dnf module install -y container-tools:ol8 >/dev/null
broadcast "Podman installed successfully."
log "Podman installed successfully."

# Allow containers to use device files
broadcast "Setting SELinux boolean for container use of device files..."
log "Setting SELinux boolean for container use of device files..."
sudo setsebool -P container_use_devices 1
sudo setsebool -P container_manage_cgroup on
broadcast "SELinux boolean set successfully."
log "SELinux boolean set successfully."

# Login to nvcr.io
broadcast "Logging in to nvcr.io..."
log "Logging in to nvcr.io..."
echo "Logging in to nvcr.io..."
sudo podman login nvcr.io --username '$oauthtoken' --password $api_key >/dev/null
broadcast "Logged in to nvcr.io successfully."
log "Logged in to nvcr.io successfully."

# Pull cuopt from nvcr.io
broadcast "Pulling cuopt from nvcr.io. This may take a while..."
log "Pulling cuopt from nvcr.io..."
sudo podman pull nvcr.io/nvidia/cuopt/cuopt:24.03 >/dev/null
broadcast "cuopt pulled successfully."
log "cuopt pulled successfully."

# Create systemd service file for cuopt
broadcast "Creating systemd service file..."
log "Creating systemd service file..."
sudo tee /etc/systemd/system/cuopt.service >/dev/null <<EOF
[Unit]
Description=Podman cuopt Container
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/bin/podman run --rm --device nvidia.com/gpu=all -p 5000:5000 nvcr.io/nvidia/cuopt/cuopt:24.03

[Install]
WantedBy=multi-user.target
EOF
broadcast "Systemd service file created successfully."
log "Systemd service file created successfully."

# Reload systemd and start the service
broadcast "Reloading systemd and starting cuopt service..."
log "Reloading systemd..."
sudo systemctl daemon-reload
log "Starting cuopt service..."
sudo systemctl start cuopt.service

# Enable automatic start on boot
broadcast "Enabling cuopt service to start on boot..."
log "Enabling cuopt service to start on boot..."
sudo systemctl enable cuopt.service
broadcast "cuopt service enabled to start on boot."
log "cuopt service enabled to start on boot."

# Broadcast and log completion of installation
broadcast "Installation of nvidia-container-toolkit and cuopt completed successfully."
log "Installation of nvidia-container-toolkit and cuopt completed successfully."

log "Setup completed successfully."