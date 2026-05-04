#!/bin/bash
set -euo pipefail

datetime=$(date +%Y-%m-%d-%H-%M-%S)
template=$(echo "$1" | tr '[:upper:]' '[:lower:]')
common_dir="$(dirname "$0")/base-images/common"

if ! command -v packer &> /dev/null; then
    echo "packer could not be found, please install packer cli first"
    exit 1
fi

case $template in
    fedora)
        echo "Building Fedora template..."
        dir="$(dirname "$0")/base-images/fedora"
        echo "${datetime} -- running packer init..."
        packer init "${dir}/fedora.pkr.hcl" > /dev/null 2>&1
        echo "${datetime} -- starting build process..."
        packer build -force -on-error=ask "${common_dir}" "${dir}"
        echo "${datetime} -- packer build completed successfully."
        ;;
    ubuntu)
        echo "Building Ubuntu template..."
        read -r -p "Enter the Ubuntu version (e.g., 24.04): " ubuntu_version
        if [[ "$ubuntu_version" != "24.04" && "$ubuntu_version" != "22.04" ]]; then
            echo "Unsupported Ubuntu version: ${ubuntu_version}"
            exit 1
        fi
        dir="$(dirname "$0")/base-images/ubuntu/ubuntu-${ubuntu_version}"
        if [[ ! -d "$dir" ]]; then
            echo "Build directory not found: ${dir}"
            exit 1
        fi
        echo "${datetime} -- running packer init..."
        packer init "${dir}/ubuntu-${ubuntu_version}.pkr.hcl" > /dev/null 2>&1
        echo "${datetime} -- starting build process..."
        packer build -force -on-error=ask "${common_dir}" "${dir}"
        echo "${datetime} -- packer build completed successfully."
        ;;
    talos)
        echo "Building Talos template..."
        dir="$(dirname "$0")/base-images/talos"
        packer init "${dir}/talos.pkr.hcl" > /dev/null 2>&1
        echo "${datetime} -- starting build process..."
        packer build -force -on-error=ask \
            -var-file="${dir}/vars/secrets.pkrvars.hcl" \
            -var-file="${dir}/vars/local.pkrvars.hcl" \
            "${dir}/talos.pkr.hcl"
        echo "${datetime} -- packer build completed successfully."
        ;;
    *)
        echo "Usage: $0 [fedora|ubuntu|talos]"
        exit 1
        ;;
esac
