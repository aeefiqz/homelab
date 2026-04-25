#!/bin/bash
set -euo pipefail

datetime=$(date +%Y-%m-%d-%H-%M-%S)
template=$(echo "$1" | tr '[:upper:]' '[:lower:]')

if ! command -v packer &> /dev/null; then
    echo "packer could not be found, please install packer cli first"
    exit 1
fi

init_packer() {
    local template_file="${template}.pkr.hcl"
    packer init "$template_file" > /dev/null 2>&1
    echo "${datetime} -- packer init successful..."
    echo "${datetime} -- starting build process..."
    packer build -force -on-error=ask \
        -var-file=./variables.pkr.hcl \
        -var-file=./secrets.pkr.hcl \
        "$template_file"
    echo "${datetime} -- packer build completed successfully."
}

case $template in
    talos)
        echo "Building Talos template..."
        cd "$(dirname "$0")/talos"
        init_packer
        ;;
    ubuntu)
        echo "Building Ubuntu template..."
        cd "$(dirname "$0")/ubuntu"
        init_packer
        ;;
    *)
        echo "Usage: $0 [talos|ubuntu]"
        exit 1
        ;;
esac