#!/usr/bin/env bash
set -euo pipefail 

APP_LIST=(
    "terraform"
    "awscli"
    "ansible"
    "packer"
    "kubectl"
    "k9s"
)

DEFAULT_SHELL=$(basename $SHELL)

SHELL_PROFILE="$HOME/.${DEFAULT_SHELL}rc"

if [ ! -f $SHELL_PROFILE ]; then
    touch $SHELL_PROFILE
fi

setup_shell_profile() {
    echo "Setting up shell profile for $DEFAULT_SHELL..."
    if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$SHELL_PROFILE"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_PROFILE"
        echo "Added ~/.local/bin to PATH in $SHELL_PROFILE"
        echo "Setting up kubectl aliases in $SHELL_PROFILE..."
        cat << EOF >> "$SHELL_PROFILE"
        alias k='kubectl'
        alias kconf='kubectl config'
        alias ka='kubectl apply -f'
        alias kadry='kubectl apply -f --dry-run=client -o yaml'
        alias kg='kubectl get'
        alias kgp='kubectl get pods'
        alias kgd='kubectl get deployments'
        alias kgs='kubectl get secrets'
        alias kgsvc='kubectl get services -o wide'
        alias kgn='kubectl get nodes -o wide'
        alias kgns='kubectl get namespaces'
        alias kgrs='kubectl get replicasets'
        alias kgcm='kubectl get configmaps'
        alias kgcj='kubectl get cronjobs'
        alias kgj='kubectl get jobs'
        alias kgsa='kubectl get serviceaccounts'
        alias kgr='kubectl get role'
        alias kgrb='kubectl get rolebinding'
        alias kgcr='kubectl get clusterrole'
        alias kgcrb='kubectl get clusterrolebinding'
        alias kd='kubectl describe'
        alias kdp='kubectl describe pod'
        alias kdd='kubectl describe deployment'
        alias kds='kubectl describe service'
        alias kr='kubectl delete -f'
        alias kl='kubectl logs'
        alias kexec='kubectl exec -it'
EOF
    else
        echo "PATH already configured in $SHELL_PROFILE"
    fi
}


detect_os() {
    echo "Detecting operating system..."
    OS_TYPE=$(uname -s)
    case "$OS_TYPE" in 
        Linux*)     OS="Linux";;
        Darwin*)    OS="Mac";;
        *)          echo "Unsupported operating system: $OS_TYPE"; exit 1;;
    esac
}

check_package_manager() {
    
}

install_apps() {
    for app in "${APP_LIST[@]}"; do
        if ! command -v "$app" >/dev/null 2>&1; then
            echo "Installing $app..."
            
        else
            echo "$app is already installed."
        fi
    done
}