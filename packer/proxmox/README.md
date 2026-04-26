### Overview
This folder is where all the packer configurations and files are stored according to their distro.

### Folder structure
```
proxmox/
├── alphine/                    # Application source code
│   ├── alphine-xxx/         # [what this module handles]
│   ├── alphine-xxx/         # [what this module handles]         
├── talos/
│   ├── talos-xxx/         # [what this module handles]
│   ├── talos-xxx/         # [what this module handles]
├── ubuntu/                  # Unit and integration tests
│   ├── ubuntu-xxx/         # [what this module handles]
│   ├── ubuntu-xxx/         # [what this module handles]
├── cicd/ 
├── docs/                   # Documentation assets (demo GIF, diagrams)
├── scripts/                # Helper / automation scripts
├── .env.example            # Environment variable template
├── [config-file]           # e.g. Dockerfile, docker-compose.yml, pyproject.toml
└── README.md
```

### Pre-requisites
- packer

### How to run build packer image
Navigate to the root directory and run `build.sh` with your distro of choice.
e.g. `build.sh ubuntu`
