UNIX Version 4 – Acquisition Notes

This document describes how users may lawfully acquire, validate, and prepare Research UNIX Version 4 media for use with the Kube-Archive UNIX-V4 experiment.

No UNIX source code, binaries, disk images, tapes, or ROMs are distributed with this repository.


---

Historical Context

Research UNIX Version 4 (1973) was developed at AT&T Bell Laboratories for the DEC PDP-11 platform. Distribution was historically limited to licensed academic and research institutions.

Today, UNIX V4 survives primarily through archival preservation efforts.


---

Lawful Acquisition Sources

Users must obtain UNIX V4 media from legitimate sources. Examples include:

University computing history archives

Licensed institutional UNIX history collections

Research copies obtained through academic agreements

Lawfully cleared historical UNIX distributions


This project does not endorse unauthorized redistribution.


---

Expected Media Type

The UNIX-V4 container expects a pre-installed RK05 disk image compatible with SIMH PDP-11 emulation.

Required File

unixv4.dsk

Disk Characteristics

PDP-11 RK05 disk format

Bootable UNIX V4 filesystem

SIMH-compatible raw disk image



---

File Placement

At runtime, the disk image must be mounted into the container at:

/data/unixv4.dsk

For example (Docker):

docker run -it \
  -v $(pwd)/data:/data \
  unix-v4:latest


---

Validation Recommendations

Before use, users should:

Verify the provenance of the image

Record acquisition source and context

Optionally compute checksums for personal records


Example:

sha256sum unixv4.dsk


---

Naming Convention

To ensure compatibility, users should name the disk image exactly:

unixv4.dsk

Alternate naming is possible but requires editing unixv4.ini.


---

Ethical and Legal Responsibility

By supplying UNIX V4 media to this container, the user affirms that:

The media was lawfully obtained

Usage complies with applicable licenses or agreements

The media will not be redistributed unlawfully



---

Purpose

These acquisition constraints ensure that Kube-Archive remains:

Legally compliant

Ethically responsible

Suitable for educational, archival, and research use
