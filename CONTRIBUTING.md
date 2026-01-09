# Contributing

Kube-Archive welcomes contributions of unusual and educational
Kubernetes deployments that run actual software stacks, not synthetic
mockups or toy simulations.

## Guidelines

- One experiment per directory under `Experiments/`
- Each experiment must include:
  - a README explaining context and usage
  - build instructions (if applicable)
  - Kubernetes manifests and/or Helm chart
- Do not commit copyrighted ROM images or proprietary firmware
- If binaries are required, link to their source/provenance
- Prefer reproducibility and minimal magic

## Safety + Legal Notes

Historical computer artifacts may involve licensed software and
emulation. If in doubt, link instead of vendoring assets.


## Legal and Licensing

Kube-Archive is licensed under Apache-2.0.

Do not commit any proprietary ROMs, firmware dumps, tape images, disk images,
or copyrighted binary artifacts. If an experiment depends on such an artifact,
provide instructions and provenance for acquiring it externally.

Allowed:
- open-source emulators and tools
- open-source flight software
- public domain historical software
- configuration files, Dockerfiles, scripts, manifests

Not Allowed:
- proprietary ROM dumps
- proprietary operating system binaries
- firmware images not explicitly licensed for redistribution
- leaked code or uncontrolled ITAR materials

If in doubt, open an issue before submitting.
