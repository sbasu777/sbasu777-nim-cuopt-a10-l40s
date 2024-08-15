# Deploy NVIDIA cuOpt on Oracle Linux on A10 Instance

This Oracle Cloud Infrastructure (OCI) Resource Manager stack deploys an A10 (VM.GPU.A10.1) instance running Oracle Linux and installs NVIDIA cuOpt in an existing Virtual Cloud Network (VCN).

## Prerequisites

1. **OCI Account**: Ensure you have an active Oracle Cloud Infrastructure account.
2. **NVIDIA NGC API Key**: You need a valid NVIDIA NGC Catalog API key to complete the deployment.
3. **SSH Key Pair**: Generate an SSH key pair to access the deployed instance.

## Resource Configuration

### General Configuration

This configuration section is not visible in the deployment UI:

- **Tenancy OCID**: OCID of your tenancy.
- **Region**: Region where the resources will be deployed.

### Required Configuration

These variables are visible and need to be configured in the deployment UI:

- **Compartment OCID**: Choose the compartment where you want to deploy the GPU VM.
- **VCN ID**: Select the VCN (Virtual Cloud Network) where the resources will be deployed.
- **Subnet ID**: Select the subnet within the VCN for resource deployment.
- **VM Display Name**: Set a display name for the VM instance.
- **SSH Public Key**: Upload your public SSH key for accessing the compute instance.
- **Availability Domain**: Choose the availability domain for the instance.
- **NVIDIA API Key**: Enter your NVIDIA API key.

## Variables

The following variables need to be configured for the stack:

- **compartment_ocid**: OCID of the compartment where the resources will be deployed.
- **vcn_id**: OCID of the VCN.
- **subnet_id**: OCID of the subnet.
- **vm_display_name**: Display name for the VM.
- **ssh_public_key**: Your public SSH key.
- **ad**: Name of the availability domain.
- **nvidia_api_key**: NVIDIA cuOpt API key.

## Post Deployment

After the deployment completes:

1. **Verify Installation**: Connect to the instance via SSH and verify that NVIDIA cuOpt is installed by running systemctl status cuopt.
2. **Run cuOpt**: Follow NVIDIA's documentation to start using cuOpt on your Oracle Linux instance.



[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/guido-orcl/nvidia-cuopt-a10/archive/refs/heads/main.zip)
