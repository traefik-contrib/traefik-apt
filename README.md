# Traefik APT Package Builder for Ubuntu and Debian

This repository provides the necessary tools to build APT packages of Traefik for Ubuntu and Debian systems. It includes configurations to enhance security and manageability, ideal for deploying Traefik as a standalone service.

## Current Work

* a signed APT repository
* and automating the build workflow to sync with Traefik's upstream releases
* unit test against distros

## Download Packages

While we finalize the repository signing and automation, you can download the current `.deb` files directly. 
Please verify the SHA256 checksums to confirm the integrity of the downloaded files.

### Packages

- [Debian 12: traefik_3.0.0-1_amd64.deb](https://apt.gradusrepo.com/dists/debian/12/main/binary-amd64/traefik_3.0.0-1_amd64.deb)
- [Ubuntu 22.04: traefik_3.0.0-1_amd64.deb](https://apt.gradusrepo.com/dists/ubuntu/22.04/main/binary-amd64/traefik_3.0.0-1_amd64.deb)
- [Ubuntu 24.04: traefik_3.0.0-1_amd64.deb](https://apt.gradusrepo.com/dists/ubuntu/24.04/main/binary-amd64/traefik_3.0.0-1_amd64.deb)

### Checksums

Ensure the authenticity and integrity of your downloads by checking their SHA256 checksums:

- [SHA256SUM.txt](https://apt.gradusrepo.com/SHA256SUM.txt)

## Features

- **Log Management**: Integration with `logrotate` to manage log files efficiently.
- **Example Configuration**: Includes a `traefik.yml` example for redirecting traffic from port 80 to 8000.
- **Systemd Service**: Robust service management with systemd, configured to run as the `www-data` user for enhanced security:
  - `AmbientCapabilities=CAP_NET_BIND_SERVICE` allows binding to well-known ports without elevated privileges.
  - `Restart=always` ensures the service restarts automatically if it crashes.
  - Enhanced filesystem and service isolation with several security directives such as `ProtectSystem=strict` and `PrivateTmp=true`.
  - Specified `ReadWritePaths` for restricting read-write permissions to essential paths like `/etc/traefik/acme.json` and `/var/log/traefik/`.

## Supported Distributions

Currently, we have builds available for the following distributions:
- Ubuntu 24.04 LTS
- Ubuntu 22.04 LTS
- Debian 12

## Prerequisites

- Docker or Podman installed on your machine.
- Basic knowledge of Docker and Makefile usage.

## Usage Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/traefik-contrib/traefik-apt.git
   cd traefik-apt

2. **Configure Environment Variables**:
Edit the .env file to set up environment variables such as PKG_VERSION, PKG_RELEASE, and others as per your requirements.


3. **Build Specific Distribution**:

To build a package for Ubuntu 24.04:
```
make build_docker_ubuntu_24_04
```

For Ubuntu 22.04 LTS:
```
make build_docker_ubuntu_22_04
```

For Debian 12:
```
make build_debian_12
```


## Extending Support
This setup can be enhanced to support additional Debian and Ubuntu releases by modifying the Dockerfiles and adjusting the build scripts accordingly.

## Contributing
Contributions are welcome! Please fork the repository and submit pull requests with your enhancements. For major changes, please open an issue first to discuss what you would like to change.
