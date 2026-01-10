# Unix V4 on Kubernetes

Run the first C-based Unix kernel (1973) in your Kubernetes cluster.

## Prerequisites

- Kubernetes cluster
- `kubectl` configured
- Container image built and pushed to a registry

## Quick Start

### 1. Build and push the container image

```bash
# Build
docker build -t your-registry/unix-v4:latest .

# Push
docker push your-registry/unix-v4:latest
```

### 2. Update the deployment

Edit `unix-v4-deployment.yaml` and update the image reference:
```yaml
image: your-registry/unix-v4:latest
```

### 3. Initialize the data volume

This downloads the disk image to the PVC:
```bash
chmod +x init-data.sh
./init-data.sh
```

### 4. Deploy

```bash
kubectl apply -f unix-v4-deployment.yaml
```

### 5. Connect

Option A - Via kubectl exec + telnet:
```bash
kubectl exec -it deploy/unix-v4 -n unix-v4 -- telnet localhost 5555
```

Option B - Port forward:
```bash
kubectl port-forward -n unix-v4 svc/unix-v4 5555:5555 &
telnet localhost 5555
```

### 6. Boot Unix

At the `=` prompt:
```
k
unix
```

Login as `root` (no password).

## Usage Tips

- Use `chdir` instead of `cd`
- Backspace may not work; use `#` to delete, `@` to kill line
- Exit cleanly: `sync` then Ctrl+E for SIMH prompt, then `quit`
- The date will show 1974 - that's expected!

## Commands to Try

```
ls /bin
who
cat /etc/passwd
chdir /usr
ls
```

## Architecture

```
┌─────────────────────────────────────┐
│  Kubernetes Cluster                 │
│  ┌───────────────────────────────┐  │
│  │ Pod: unix-v4                  │  │
│  │ ┌───────────────────────────┐ │  │
│  │ │ SIMH PDP-11 Emulator      │ │  │
│  │ │ ┌───────────────────────┐ │ │  │
│  │ │ │ Unix V4 (1973)        │ │ │  │
│  │ │ │ - Kernel in C         │ │ │  │
│  │ │ │ - ~27KB kernel        │ │ │  │
│  │ │ └───────────────────────┘ │ │  │
│  │ │ Telnet Console :5555     │ │  │
│  │ └───────────────────────────┘ │  │
│  │ Volume: /data/disk.rk         │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## Historical Context

Unix V4 (November 1973) was the first version where the kernel was
substantially rewritten in C. The original tape was discovered at
the University of Utah in July 2025 and recovered by Al Kossow at
the Computer History Museum in December 2025.

The kernel is approximately 27KB - smaller than most web cookies.
