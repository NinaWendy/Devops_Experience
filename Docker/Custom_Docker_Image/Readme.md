
# Dockerhub Repositories

- [ppc64le/elixir](https://hub.docker.com/r/ppc64le/elixir)
- [ppc64le/alpine](https://hub.docker.com/r/ppc64le/alpine)

## Use BuildKit to Extend Build Functionality

```sh
docker buildx build --platform linux/ppc64le -t elixir-erlang-powerpc64le-custom-image:v1 --load .
```

## Push to Registry

```sh
docker buildx build --platform linux/ppc64le --output=type=registry -t wbusolo/elixir-erlang-powerpc64le-custom-image:v1 --load .
```
