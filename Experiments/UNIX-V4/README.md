# UNIX V4 on Kubernetes

Run Research UNIX Fourth Edition (November 1973) on a PDP-11 emulator (SIMH) inside Kubernetes.

**Status:** ✅ Working

## Overview

UNIX V4 was the first version of UNIX where the kernel was substantially rewritten in C (previously it was assembly). The original tape was discovered at the University of Utah in July 2025 and successfully recovered by Al Kossow at the Computer History Museum in December 2025.

This deployment runs the historically significant operating system inside a containerized PDP-11 emulator, accessible via telnet.

### Technical Specs

| Component | Details |
|-----------|---------|
| OS | Research UNIX Fourth Edition (November 1973) |
| Kernel Size | ~27KB |
| Codebase | ~55,000 lines (~25,000 in C) |
| Emulator | SIMH PDP-11 (simulating PDP-11/45) |
| Disk Image | RK05 (2.4MB) |
| Console Access | Telnet on port 5555 |

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Kubernetes Cluster                                         │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Namespace: unix-v4                                    │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │ Pod: unix-v4                                    │  │  │
│  │  │  ┌───────────────────────────────────────────┐  │  │  │
│  │  │  │ Container: pdp11                          │  │  │  │
│  │  │  │  ┌─────────────────────────────────────┐  │  │  │  │
│  │  │  │  │ SIMH PDP-11/45 Emulator             │  │  │  │  │
│  │  │  │  │  ┌───────────────────────────────┐  │  │  │  │  │
│  │  │  │  │  │ UNIX V4 (1973)                │  │  │  │  │  │
│  │  │  │  │  │ - First C-based kernel       │  │  │  │  │  │
│  │  │  │  │  │ - ~27KB kernel size          │  │  │  │  │  │
│  │  │  │  │  └───────────────────────────────┘  │  │  │  │  │
│  │  │  │  │ Telnet Console: 5555               │  │  │  │  │
│  │  │  │  └─────────────────────────────────────┘  │  │  │  │
│  │  │  └───────────────────────────────────────────┘  │  │  │
│  │  │  Volume: /data/disk.rk (RK05 disk image)       │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │                                                       │  │
│  │  Service: unix-v4:5555 (ClusterIP)                   │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

- Docker
- Kubernetes cluster (tested on k3s)
- `kubectl` configured
- `helm` v3+
- `telnet` client

## Repository Structure

```
UNIX-V4/
├── README.md
├── Container/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── unixv4-boot.ini
│   ├── unixv4-install.ini
│   └── README.md
└── Helm/
    ├── Chart.yaml
    ├── values.yaml
    ├── init-data.sh
    ├── README.md
    └── templates/
        ├── deployment.yaml
        ├── service.yaml
        └── pvc.yaml
```

## Quick Start

### Step 1: Build and Push the Container Image

```bash
cd Container/

# Build the image
docker build -t unix-v4:latest .

# Tag for Docker Hub (replace with your username)
docker tag unix-v4:latest yourusername/unix-v4:latest

# Push to Docker Hub
docker push yourusername/unix-v4:latest
```

### Step 2: Update Helm Values

Edit `Helm/values.yaml` and update the image repository:

```yaml
image:
  repository: yourusername/unix-v4
  tag: latest
  pullPolicy: Always
```

### Step 3: Deploy with Helm

```bash
cd Helm/

# Install the Helm chart
helm install unix-v4 . -n unix-v4 --create-namespace
```

### Step 4: Initialize the Disk Image

The PDP-11 emulator needs the UNIX V4 disk image. Download it to the persistent volume:

```bash
kubectl run unix-v4-disk-init --rm -i --restart=Never \
  --namespace=unix-v4 \
  --image=curlimages/curl:latest \
  --overrides='{
    "spec": {
      "containers": [{
        "name": "init",
        "image": "curlimages/curl:latest",
        "command": ["sh", "-c", "cd /data && curl -L -O http://squoze.net/UNIX/v4/disk.rk && ls -la /data"],
        "volumeMounts": [{
          "name": "data",
          "mountPath": "/data"
        }]
      }],
      "volumes": [{
        "name": "data",
        "persistentVolumeClaim": {
          "claimName": "unix-v4-data"
        }
      }]
    }
  }'
```

### Step 5: Restart the Deployment

```bash
kubectl rollout restart deployment/unix-v4 -n unix-v4
```

### Step 6: Verify the Pod is Running

```bash
kubectl get pods -n unix-v4
```

Expected output:
```
NAME                       READY   STATUS    RESTARTS   AGE
unix-v4-6d7dccf87f-r8k2r   1/1     Running   0          30s
```

### Step 7: Connect to UNIX V4

**Terminal 1 - Port Forward:**
```bash
kubectl port-forward -n unix-v4 svc/unix-v4 5555:5555
```

**Terminal 2 - Telnet:**
```bash
telnet localhost 5555
```

### Step 8: Boot UNIX V4

At the `=` prompt (this is the PDP-11 boot loader):
```
k
unix
```

You should see:
```
mem = 64530

login:
```

Login as `root` (no password).

**Congratulations! You're now running UNIX from 1973 in Kubernetes!**

## Using UNIX V4

### Important Differences from Modern UNIX

UNIX V4 predates many conventions we take for granted:

| Modern Command | UNIX V4 Equivalent |
|---------------|-------------------|
| `cd` | `chdir` |
| Backspace | `#` (delete char) |
| Ctrl+U (kill line) | `@` |
| Tab completion | Not available |
| Arrow keys | Not available |
| Command history | Not available |

### Basic Commands

```bash
# List files
ls
ls -l

# Change directory
chdir /bin
chdir /usr

# Show current user
who

# Show date (will show 1974!)
date

# View file contents
cat /etc/passwd

# Show running processes
ps
```

### Exploring the System

```bash
# List available commands
ls /bin

# View system files
chdir /etc
ls

# Explore user files
chdir /usr
ls

# View the kernel
ls -l /unix
```

### Available Programs

Some programs available in `/bin`:
- `as` - assembler
- `cat` - concatenate files
- `chmod` - change permissions
- `chown` - change owner
- `cmp` - compare files
- `cp` - copy files
- `date` - show date
- `db` - debugger
- `dc` - desk calculator
- `ed` - text editor
- `ld` - link editor
- `ln` - create links
- `ls` - list directory
- `mkdir` - make directory
- `mv` - move files
- `nm` - name list
- `od` - octal dump
- `pr` - print file
- `rm` - remove files
- `rmdir` - remove directory
- `sh` - shell
- `strip` - strip symbols
- `su` - substitute user
- `sync` - sync disks
- `who` - who is logged in
- `write` - write to user

### The C Compiler

UNIX V4 includes the C compiler:

```bash
chdir /usr/source
ls
```

## Troubleshooting

### Pod in CrashLoopBackOff

**Cause:** The disk image (`disk.rk`) is missing from the persistent volume.

**Solution:** Run the init command from Step 4 to download the disk image.

```bash
kubectl logs -n unix-v4 <pod-name>
```

If you see "ERROR: missing disk image", the disk.rk file wasn't downloaded.

### Cannot Connect via Telnet

**Cause:** Port forward not running or service not ready.

**Solution:**
```bash
# Check pod is running
kubectl get pods -n unix-v4

# Check service exists
kubectl get svc -n unix-v4

# Restart port forward
kubectl port-forward -n unix-v4 svc/unix-v4 5555:5555
```

### Telnet Connects but No Response

**Cause:** SIMH is waiting for boot commands.

**Solution:** Type `k` then Enter, then `unix` then Enter at the `=` prompt. The prompt may not be visible initially.

### Keyboard Not Working Properly

**Cause:** UNIX V4 uses different control characters.

**Solution:**
- Use `#` to delete characters (not Backspace)
- Use `@` to kill the entire line (not Ctrl+U)
- There is no command history or tab completion

### Date Shows 1974

**Expected behavior!** The disk image preserves the original date. This is historically accurate.

## Cleanup

To remove the deployment:

```bash
# Uninstall Helm release
helm uninstall unix-v4 -n unix-v4

# Delete namespace (removes PVC and all resources)
kubectl delete namespace unix-v4
```

## Container Details

### Dockerfile

The container:
1. Builds SIMH from source (github.com/simh/simh)
2. Installs the PDP-11 simulator
3. Configures telnet console access on port 5555
4. Mounts disk images from `/data`

### SIMH Configuration

The boot configuration (`unixv4-boot.ini`):
```ini
set cpu 11/45
set cpu idle
set tti 7b
set tto 7b
set console telnet=5555
set console pchar=0
att rk0 /data/disk.rk
boot rk0
```

## Historical Context

### The Discovery

In July 2025, a nine-track tape reel was discovered in a storage closet at the University of Utah's Kahlert School of Computing. The tape was found among the documents of Jay Lepreau in the Flux Research Group's storage in the Merrill Engineering Building.

The tape was delivered to the Computer History Museum, where software curator Al Kossow successfully recovered the contents in December 2025 using a modified tape reader and Len Shustek's readtape tool.

### Significance

UNIX V4 (November 1973) represents a pivotal moment in computing history:

- **First C-based kernel:** The kernel was substantially rewritten from assembly to C
- **Portability foundation:** This rewrite enabled UNIX to be ported to other architectures
- **Modern OS ancestor:** Direct ancestor of Linux, macOS, BSD, and virtually all modern operating systems

The kernel is approximately 27KB - smaller than most modern web cookies or tracking scripts.

### The Utah Connection

The tape was originally delivered to Martin Newell, a computer scientist best known for creating the "Utah Teapot" - a standard reference object in 3D computer graphics. Newell worked at the University of Utah from 1972 to 1979 before moving to Xerox PARC.

## References

- [Computer History Museum - UNIX V4 Recovery](https://archive.org/details/utah_unix_v4_raw)
- [squoze.net - UNIX V4 Documentation](http://squoze.net/UNIX/v4/README)
- [The Register - UNIX V4 Successfully Recovered](https://www.theregister.com/2025/12/23/unix_v4_tape_successfully_recovered/)
- [SIMH - Computer History Simulation Project](https://github.com/simh/simh)

## License

UNIX V4 was made freely available by Caldera International under the BSD 4-Clause license on January 23, 2002.

## Acknowledgments

- **Al Kossow** (Computer History Museum) - Tape recovery
- **Len Shustek** - readtape tool
- **aap** (squoze.net) - UNIX V4 reconstruction and documentation
- **The SIMH Project** - PDP-11 emulator
