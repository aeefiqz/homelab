#!/bin/bash
set -euo pipefail

datetime=$(date +%Y-%m-%d-%H-%M-%S)
template=$(echo "$1" | tr '[:upper:]' '[:lower:]')

if ! command -v packer &> /dev/null; then
    echo "packer could not be found, please install packer cli first"
    exit 1
fi

init_packer() {
    local dir="$1"
    local template_file="${2}.pkr.hcl"
    echo "${datetime} -- running packer init..."
    packer init "${dir}/${template_file}" > /dev/null 2>&1
    echo "${datetime} -- starting build process..."
    packer build -force -on-error=ask "${dir}/${template_file}"
    echo "${datetime} -- packer build completed successfully."
}

case $template in
    talos)
        echo "Building Talos template..."
        dir="$(dirname "$0")/talos"
        packer init "${dir}/talos.pkr.hcl" > /dev/null 2>&1
        echo "${datetime} -- starting build process..."
        packer build -force -on-error=ask \
            -var-file="${dir}/vars/secrets.pkrvars.hcl" \
            -var-file="${dir}/vars/local.pkrvars.hcl" \
            "${dir}/talos.pkr.hcl"
        echo "${datetime} -- packer build completed successfully."
        ;;
    ubuntu)
        echo "Building Ubuntu template..."
        read -r -p "Enter the Ubuntu version (e.g., 24.04): " ubuntu_version
        if [[ "$ubuntu_version" != "24.04" && "$ubuntu_version" != "22.04" ]]; then
            echo "Unsupported Ubuntu version: ${ubuntu_version}"
            exit 1
        fi
        dir="$(dirname "$0")/ubuntu/ubuntu-${ubuntu_version}"
        if [[ ! -d "$dir" ]]; then
            echo "Build directory not found: ${dir}"
            exit 1
        fi
        echo "${datetime} -- running packer init..."
        packer init "${dir}/ubuntu-${ubuntu_version}.pkr.hcl" > /dev/null 2>&1
        echo "${datetime} -- starting build process..."
        packer build -force -on-error=ask "${dir}/ubuntu-${ubuntu_version}.pkr.hcl"
        echo "${datetime} -- packer build completed successfully."
        ;;
    *)
        echo "Usage: $0 [talos|ubuntu]"
        exit 1
        ;;
esac
