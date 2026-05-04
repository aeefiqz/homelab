### Overview
This folder is where all the packer configurations and files are stored according to their distro.

### Folder structure
```
proxmox/
├── base-images/  
    ├── alphine/                 
        ├── alphine-xxx/         # [what this module handles]
        ├── alphine-xxx/         # [what this module handles]         
    ├── talos/
        ├── talos-xxx/         # [what this module handles]
        ├── talos-xxx/         # [what this module handles]
    ├── ubuntu/                  # Unit and integration tests
        ├── ubuntu-xxx/         # [what this module handles]
        ├── ubuntu-xxx/         # [what this module handles]
├── custom-images/
├── cicd/
    ├── scripts/            # cicd scripts e.g (build, validate, git tagging)
├── docs/                   # Documentation assets (demo GIF, diagrams)
├── scripts/                # Helper / automation scripts
├── .env.example            # Environment variable template
├── [config-file]           # e.g. Dockerfile, docker-compose.yml, pyproject.toml
└── README.md
```

### Pre-requisites
- packer


### Code structure and variables 
Follow the packer configuration block structure for readability
```
 packer {

 }

 data {

 }

 locals {

 }

 source {

 }

 build {

 }
```

### How to run build packer image
Navigate to the root directory and run `build.sh` with your distro of choice.
e.g. `build.sh ubuntu`
