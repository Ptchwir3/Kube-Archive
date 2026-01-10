# Apollo Guidance Computer on Kubernetes

Run the Apollo 11 Guidance Computers (AGC) in Kubernetes using the VirtualAGC emulator.

**Status:** 🚧 In Progress

## Overview

The Apollo Guidance Computer (AGC) was the onboard computer used in the Apollo program that landed humans on the Moon. Each Apollo mission had two AGCs:

- **Command/Service Module (CSM)** - Running Colossus software
- **Lunar Module (LM)** - Running Luminary software

This project runs both AGCs as separate deployments in Kubernetes, emulating the actual flight computers from Apollo 11.

### Technical Specs

| Component | CSM (Colossus249) | LM (Luminary099) |
|-----------|-------------------|------------------|
| Spacecraft | Command Module | Lunar Module |
| Mission | Apollo 11 | Apollo 11 |
| Memory | 36,864 words ROM | 36,864 words ROM |
| | 2,048 words RAM | 2,048 words RAM |
| Clock Speed | 2.048 MHz | 2.048 MHz |
| Word Size | 15-bit + parity | 15-bit + parity |
| Emulator | yaAGC (VirtualAGC) | yaAGC (VirtualAGC) |
| Telemetry Port | 1969 | 1969 |

### Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│  Kubernetes Cluster                                                 │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │ Namespace: apollo                                             │  │
│  │                                                               │  │
│  │  ┌─────────────────────────┐  ┌─────────────────────────┐    │  │
│  │  │ Pod: apollo-agc-csm     │  │ Pod: apollo-agc-lm      │    │  │
│  │  │  ┌───────────────────┐  │  │  ┌───────────────────┐  │    │  │
│  │  │  │ yaAGC Emulator    │  │  │  │ yaAGC Emulator    │  │    │  │
│  │  │  │ ┌───────────────┐ │  │  │  │ ┌───────────────┐ │  │    │  │
│  │  │  │ │ Colossus249   │ │  │  │  │ │ Luminary099   │ │  │    │  │
│  │  │  │ │ (CSM Software)│ │  │  │  │ │ (LM Software) │ │  │    │  │
│  │  │  │ └───────────────┘ │  │  │  │ └───────────────┘ │  │    │  │
│  │  │  │ Port: 1969        │  │  │  │ Port: 1969        │  │    │  │
│  │  │  └───────────────────┘  │  │  └───────────────────┘  │    │  │
│  │  └─────────────────────────┘  └─────────────────────────┘    │  │
│  │                                                               │  │
│  │  Service: apollo-agc-csm:1969    Service: apollo-agc-lm:1969 │  │
│  │  (ClusterIP)                     (NodePort 31969)            │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

## Prerequisites

- Docker
- Kubernetes cluster (tested on k3s)
- `kubectl` configured
- `helm` v3+

## Repository Structure

```
APOLLO-K8S/
├── README.md
├── AGC-CSM/
│   ├── Container/
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   └── Helm/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           └── service.yaml
└── AGC-LM/
    ├── Container/
    │   ├── Dockerfile
    │   └── entrypoint.sh
    └── Helm/
        ├── Chart.yaml
        ├── values.yaml
        └── templates/
            ├── deployment.yaml
            └── service.yaml
```

## Deployment

### AGC-CSM (Command/Service Module)

#### Step 1: Build and Push Container

```bash
cd AGC-CSM/Container/

# Build
docker build -t apollo-agc-csm:latest .

# Tag and push to Docker Hub
docker tag apollo-agc-csm:latest ptchwir3/apollo-agc-csm:latest
docker push ptchwir3/apollo-agc-csm:latest
```

#### Step 2: Deploy with Helm

```bash
cd AGC-CSM/Helm/

# Create namespace
kubectl create namespace apollo

# Install
helm install apollo-agc-csm . -n apollo
```

#### Step 3: Verify

```bash
kubectl get pods -n apollo
kubectl logs -n apollo deploy/apollo-agc-csm
```

---

### AGC-LM (Lunar Module)

#### Step 1: Build and Push Container

```bash
cd AGC-LM/Container/

# Build
docker build -t apollo-agc-lm:latest .

# Tag and push to Docker Hub
docker tag apollo-agc-lm:latest ptchwir3/apollo-agc-lm:latest
docker push ptchwir3/apollo-agc-lm:latest
```

#### Step 2: Deploy with Helm

```bash
cd AGC-LM/Helm/

# Install (uses same namespace)
helm install apollo-agc-lm . -n apollo
```

#### Step 3: Verify

```bash
kubectl get pods -n apollo
kubectl logs -n apollo deploy/apollo-agc-lm
```

## Connecting to the AGC

### CSM (via port-forward)

```bash
kubectl port-forward -n apollo svc/apollo-agc-csm 1969:1969
```

### LM (via NodePort)

The LM is exposed on NodePort 31969:

```bash
# Connect directly to any node
nc <node-ip> 31969
```

## VirtualAGC

This project uses [VirtualAGC](https://github.com/virtualagc/virtualagc), a simulation of the Apollo Guidance Computer. The software running on the emulator is actual Apollo 11 flight software:

- **Colossus249** - Command Module software, used for navigation and re-entry
- **Luminary099** - Lunar Module software, used for the Moon landing

### yaAGC

`yaAGC` is the AGC CPU emulator. It emulates the AGC hardware and runs the original core rope memory images.

## Historical Context

### The Apollo Guidance Computer

The AGC was revolutionary for its time (1966):
- One of the first integrated circuit-based computers
- Used core rope memory (ROM) for program storage
- Software written in AGC Assembly Language
- Famously handled "1202" and "1202" alarms during Apollo 11 landing

### Apollo 11

On July 20, 1969, the Lunar Module "Eagle" landed on the Moon with Neil Armstrong and Buzz Aldrin aboard. The AGC running Luminary099 was responsible for controlling the descent and landing.

During the landing, the AGC threw several "1202" program alarms due to executive overflow (too many tasks). The software was designed to prioritize critical tasks, allowing the landing to continue safely.

### The Source Code

The original AGC source code was recovered from paper printouts and transcribed. It's now available on GitHub and contains gems like:

```agc
# TEMPORARY, I HOPE HOPE HOPE
```

and the famous:

```agc
# BURN_BABY_BURN--MASTER_IGNITION_ROUTINE
```

## Troubleshooting

### Pod in CrashLoopBackOff

Check the logs:
```bash
kubectl logs -n apollo <pod-name>
```

The yaAGC emulator may exit if it can't bind to the telemetry port.

### Cannot Connect to Telemetry

Verify the service is running:
```bash
kubectl get svc -n apollo
```

For CSM, ensure port-forward is active. For LM, verify NodePort is accessible.

## Cleanup

```bash
# Uninstall both
helm uninstall apollo-agc-csm -n apollo
helm uninstall apollo-agc-lm -n apollo

# Delete namespace
kubectl delete namespace apollo
```

## Future Plans

- [ ] Add DSKY (Display/Keyboard) web interface
- [ ] Implement inter-AGC communication
- [ ] Add mission simulation scenarios
- [ ] Telemetry visualization dashboard

## References

- [VirtualAGC Project](https://www.ibiblio.org/apollo/)
- [VirtualAGC GitHub](https://github.com/virtualagc/virtualagc)
- [Apollo 11 Source Code](https://github.com/chrislgarry/Apollo-11)
- [AGC Architecture](https://en.wikipedia.org/wiki/Apollo_Guidance_Computer)
- [NASA Apollo 11](https://www.nasa.gov/mission_pages/apollo/apollo-11.html)

## License

VirtualAGC is released under the GPL. The original Apollo software is in the public domain.
