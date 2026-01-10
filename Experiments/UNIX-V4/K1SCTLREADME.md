# k1s - Kubernetes for 1973

> "A pod is a process. Because in 1973, that's all we had."

**k1s** is a container orchestrator built entirely within UNIX V4 (November 1973), running on a PDP-11/45 emulator, inside a Docker container, orchestrated by actual Kubernetes.

**It's Kubernetes all the way down.**

## The Inception Stack

```
┌─────────────────────────────────────────────────────────────────┐
│  Kubernetes (2026)                                              │
│  └─ Docker Container                                            │
│     └─ SIMH PDP-11/45 Emulator                                  │
│        └─ UNIX V4 (November 1973)                               │
│           └─ k1s "Container Orchestrator"                       │
│              └─ "Pods" (sleep processes)                        │
└─────────────────────────────────────────────────────────────────┘
```

## Features

| Feature | k8s | k1s |
|---------|-----|-----|
| List pods | `kubectl get pods` | `sh k1sctl get pods` |
| Create pod | `kubectl create` | `sh k1sctl create pod NAME PID` |
| Delete pod | `kubectl delete pod` | `sh k1sctl delete pod NAME` |
| etcd | Distributed KV store | `/etc/k1s/` directory |
| Container runtime | containerd | `sh` + `&` |
| Networking | CNI plugins | Not invented yet |
| YAML | ✓ | Didn't exist until 2001 |

## Demo

```
# sh k1sctl get pods
NAME STATUS
my-pod1
my-pod2

# sh k1sctl delete pod my-pod1
deleted pod my-pod1

# sleep 300 &
153
# sh k1sctl create pod nginx 153
created pod nginx with pid 153

# sh k1sctl get pods
NAME STATUS
my-pod2
nginx
```

## Architecture

```
/etc/k1s/
├── pods/        # Pod definitions (future use)
├── queue/       # Command queue (future use)  
└── running/     # Active pods - contains PID files
    ├── my-pod1  # Contains: 179
    └── my-pod2  # Contains: 180

/bin/k1sctl      # The "kubectl" of 1973
```

### k1sctl Source Code

Written in UNIX V4 shell script, edited with `ed` (the only text editor):

```sh
: k1sctl
if $1x = getx goto get
if $1x = createx goto create
if $1x = deletex goto delete
echo usage: k1sctl get/create/delete pod
exit
: get
echo NAME STATUS
ls /etc/k1s/running
exit
: create
echo $4 > /etc/k1s/running/$3
echo created pod $3 with pid $4
exit
: delete
kill `cat /etc/k1s/running/$3`
rm /etc/k1s/running/$3
echo deleted pod $3
exit
```

**Total size: 348 bytes**

For comparison, the smallest Kubernetes binary is ~40MB.

## Installation

k1s comes pre-installed on the UNIX-V4 Kubernetes deployment. See [UNIX-V4](../UNIX-V4/) for deployment instructions.

Once connected to UNIX V4:

```
telnet localhost 5555
k
unix
login: root

# cat /etc/k1s/README
# sh k1sctl get pods
```

## Usage

### List Pods

```
# sh k1sctl get pods
NAME STATUS
nginx
postgres
```

### Create a Pod

1. Start a background process:
```
# sleep 300 &
153
```

2. Register it with k1s:
```
# sh k1sctl create pod my-app 153
created pod my-app with pid 153
```

### Delete a Pod

```
# sh k1sctl delete pod my-app
deleted pod my-app
```

## Limitations

Because it's 1973:

- **No automatic PID capture** - V4 shell doesn't have `$!`
- **No `ps` output** - `ps` needs `/dev/mem` configured
- **No YAML** - YAML won't be invented for 28 more years
- **No networking** - TCP/IP doesn't exist yet
- **No containers** - Just processes
- **No health checks** - If it dies, it dies
- **64KB memory limit** - PDP-11 architecture
- **Backspace doesn't work** - Use `#` to delete, `@` to kill line
- **`cd` doesn't exist** - Use `chdir`

## Historical Context

### UNIX V4 (November 1973)

- First UNIX version with kernel substantially written in C
- Ran on PDP-11/45
- ~27KB kernel size
- Recovered from original tape by Computer History Museum (December 2025)

### What Didn't Exist in 1973

- Ethernet (1973 - same year, but not widespread)
- TCP/IP (1974)
- vi editor (1976)
- BSD (1977)  
- Usenet (1980)
- DNS (1983)
- Linux (1991)
- YAML (2001)
- Kubernetes (2014)

## The Making Of

This project was built live in a single session:

1. Deployed UNIX V4 in Kubernetes using SIMH emulator
2. Connected via telnet to the PDP-11 console
3. Explored available commands (`ls /bin`)
4. Created `/etc/k1s/` directory structure
5. Wrote `k1sctl` using `ed` (line editor)
6. Tested create/delete/get operations
7. Documented in-system at `/etc/k1s/README`
8. Synced to disk for persistence

Total development time: ~2 hours
Lines of code: 17
Bytes: 348

## Files

```
K1S/
├── README.md           # This file
└── src/
    └── k1sctl          # The k1s CLI (V4 shell script)
```

The actual k1s installation lives inside the UNIX V4 disk image at:
- `/bin/k1sctl`
- `/etc/k1s/`

## Future Enhancements

- [ ] `k1sctl describe pod` - Show PID and uptime
- [ ] `k1sctl logs` - Capture stdout (if possible)
- [ ] Pod manifests in `/etc/k1s/pods/`
- [ ] k1s-controller - Auto-restart crashed pods
- [ ] Resource limits - Monitor process size
- [ ] Multi-node - Connect multiple PDP-11s (lol)

## Authors

- **Josh (ptchwir3)**

January 2026

## License

k1s is released into the public domain. 

UNIX V4 is available under BSD 4-Clause license (Caldera, 2002).

---

*"We didn't stop to ask if we should. We only asked if we could."*

*- Running Kubernetes before Kubernetes, since 1973*
