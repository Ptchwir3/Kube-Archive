![Status](https://img.shields.io/badge/status-experimental-orange.svg)
![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)
![Kubernetes](https://img.shields.io/badge/k8s-unconventional-lightgrey.svg)

## Overview

Kube-Archive is an exploration into what happens when modern container
orchestration meets historically significant or architecturally interesting
compute systems. Instead of microservices or cloud apps, it deploys early UNIX
variants, mainframe environments, aerospace flight software, and other
non-traditional workloads on Kubernetes.

The goal is not to simulate these systems with toy scripts, but to run the
actual software stacks — complete with their original operating assumptions,
interfaces, and behaviors — inside a reproducible and observable environment.

## Why Kubernetes?

Kubernetes provides several properties that make it an unexpectedly useful
platform for this kind of archival and experimental computing:

**1. Reproducibility**

Historical environments often require fragile build chains or emulator stacks.
Containerizing them makes the full system reproducible for future users without
depending on a specific workstation or OS.

**2. Isolation**

Vintage software and flight systems were rarely designed for modern networked
multi-user environments. Kubernetes isolates them safely while still allowing
controlled interaction.

**3. Deployment Semantics**

Many flight software and archival systems assume distinct “nodes” or “stations”
(e.g., ground computers, mission controllers, instrument hosts). Kubernetes maps
this concept cleanly with Deployments, StatefulSets, and Services.

**4. Distributed Testing**

Some aerospace and distributed compute systems were intended to be tested with
multiple participants. K8s allows scaling and orchestration of multi-node
experiments without bespoke lab hardware.

**5. Observability & Instrumentation**

Metrics, logs, traces, network behavior, and stdout/stderr are all first-class
citizens. This lets researchers study these systems with modern tooling.

**6. Hardware Abstraction**

Kubernetes gives us a consistent substrate to run PDP-11 emulators, AGC
interpreters, mainframe simulators, or NASA flight frameworks without caring
about the underlying workstation.

In short: Kubernetes provides a standardized test bench for both the software
and the system-level behaviors we want to preserve, explore, and understand.
