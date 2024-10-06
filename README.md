
# Docker Proxy

**Docker Proxy** is a lightweight Docker container designed to facilitate network traffic forwarding for both TCP and UDP protocols. This versatile tool allows users to specify either a remote IP address or a domain name, enabling seamless redirection of traffic to different ports.

## Features

- **Protocol Support**: Forward traffic using either TCP or UDP.
- **Domain Resolution**: Automatically resolve domain names to IP addresses.
- **Flexible Configuration**: Easily configure local and remote ports through environment variables.
- **Simple Setup**: Quick and easy Docker setup with no default port restrictions.

## Usage

### Build the Docker Image

To build the Docker image, run the following command:

```bash
git clone https://github.com/bariskisir/DockerProxy
cd DockerProxy
docker build -t dockerproxy .
```

### Run the Docker Container

You can run the container specifying the required environment variables:


```bash
docker run -d --name docker-proxy \
  --cap-add=NET_ADMIN \
  -p desired_local_port:desired_local_port/udp \
  -e REMOTE_IP="your.remote.ip" \ # IP or DOMAIN must be set
  -e REMOTE_DOMAIN="your.domain.com" \ # IP or DOMAIN must be set
  -e REMOTE_PORT="desired_remote_port" \ # Must be set
  -e LOCAL_PORT="desired_local_port" \ # Must be set
  -e PROTOCOL="udp" \ # Change to "tcp" for TCP forwarding
  --restart unless-stopped \
  bariskisir/dockerproxy
```

-   Sample
```bash
docker run -d --name docker-proxy \
  --cap-add=NET_ADMIN \
  -p 1000:1000/udp \
  -e REMOTE_IP=1.1.1.1 \
  -e REMOTE_PORT=2000 \
  -e LOCAL_PORT=1000 \
  -e PROTOCOL="udp" \
  --restart unless-stopped \
  bariskisir/dockerproxy
```

## Requirements

-   Docker installed on your machine.
-   Basic knowledge of Docker commands.

## License

This project is licensed under the MIT License.

[Dockerhub](https://hub.docker.com/r/bariskisir/dockerproxy)
