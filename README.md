# Kube-Archive

Kube-Archive is a public collection of unconventional Kubernetes
experiments focused on running historically significant or architecturally
interesting computer systems inside modern cluster environments.

The goal is not to simulate workloads with toy scripts, but to deploy
actual operating systems, emulators, flight software, and other real
compute artifacts as reproducible workloads on Kubernetes.

## Motivation

Most Kubernetes examples focus on cloud apps or microservices. Kube-Archive
explores the opposite direction: "What else can a cluster run?"

This includes:

- vintage operating systems and mainframe environments
- aerospace flight software frameworks
- microcontroller and mission systems
- early UNIX research artifacts
- unusual CPU architectures
- distributed or time-dilated compute

## Repository Layout

- `Cluster/` — local cluster configs (kind, k3d, k8s, etc.)
- `Common/` — base images, shared Helm charts, utilities
- `Experiments/` — individual unconventional deployments
- `Docs/` — design notes, conventions, and roadmap

Each experiment lives under `Experiments/<Name>/` and includes:

- Dockerfile + emulator/FSW configs
- Kubernetes manifests
- optional Helm chart
- README explaining purpose & usage

## Status

Early stage — contributions and strange ideas welcome.
