# Limitations

## Distribution Method

Atlassian Confluence is distributed as a vendor binary — not through OS package managers (apt, yum, dnf, zypper). This cookbook downloads the standalone tarball directly from Atlassian's download site.

- **Standalone tarball** (`atlassian-confluence-<version>.tar.gz`): Platform-independent Java application archive
- **Binary installer** (`atlassian-confluence-<version>-x64.bin`): 64-bit Linux only

This cookbook uses the **standalone tarball** method.

## Package Availability

### APT (Debian/Ubuntu)

No official Atlassian apt repository exists. Confluence is not available via apt.

### DNF/YUM (RHEL family)

No official Atlassian yum/dnf repository exists. Confluence is not available via yum or dnf.

### Zypper (SUSE)

No official Atlassian zypper repository exists. Confluence is not available via zypper.

## Architecture Limitations

- The standalone tarball is a Java application and is architecture-independent
- The binary installer is available for **x86_64 (64-bit) only**
- arm64 (aarch64) is supported via the standalone tarball since it is pure Java

## Operating System Support

Atlassian officially supports "Linux (most distributions)" without specifying particular distributions. The cookbook supports:

- AlmaLinux 8, 9
- Amazon Linux 2023
- CentOS Stream 9
- Debian 12
- Fedora (latest)
- Oracle Linux 8, 9
- Red Hat Enterprise Linux 8, 9
- Rocky Linux 8, 9
- Ubuntu 22.04, 24.04

### Unsupported

- Alpine Linux 3.5 and earlier (known Atlassian incompatibility)
- Windows Nano
- macOS / OSX (evaluation only per Atlassian)

## Java Requirements

- Confluence requires **Java 21** (Oracle JDK or Eclipse Temurin)
- The standalone tarball does **not** bundle a JRE — Java must be installed separately
- The binary installer bundles Temurin Java 21

This cookbook does **not** manage Java installation. Use a separate cookbook such as [java](https://github.com/sous-chefs/java).

## Known Issues

- Confluence will not work with MariaDB (use MySQL 8.4 instead)
- Confluence will not work with Percona Server
- This cookbook does not manage database or reverse proxy configuration
