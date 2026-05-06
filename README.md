# Yolks

Pelican Panel runtime images ("yolks") maintained by **Goated Geese (GG-AU)**.

- Maintainer: [hello@gg-au.com](mailto:hello@gg-au.com)
- Eggs that consume these yolks: [github.com/Goated-Geese/Eggs](https://github.com/Goated-Geese/Eggs)
- Pelican custom yolk reference: [pelican.dev/docs/eggs/creating-a-custom-yolk](https://pelican.dev/docs/eggs/creating-a-custom-yolk)

Each yolk follows the Pelican Wings contract: user `container`, home `/home/container`, `WORKDIR /home/container`, `tini` as PID 1, and an `entrypoint.sh` that expands `STARTUP` placeholders before executing the server command.

## Available images

| Tag | Source | Base | Notes |
| --- | --- | --- | --- |
| `dotnet_10` | [`dotnet/10/Dockerfile`](dotnet/10/Dockerfile) | `mcr.microsoft.com/dotnet/runtime:10.0-noble` (Ubuntu 24.04, glibc 2.39+) | Use when native libraries require **GLIBC >= 2.38** (e.g. Facepunch s&box `libengine2.so`). The upstream `ghcr.io/pelican-eggs/yolks:dotnet_10` is Debian Bookworm (~glibc 2.36) and fails for those binaries. |

Pull:

```bash
docker pull ghcr.io/goated-geese/yolks:dotnet_10
```

Sanity check:

```bash
docker run --rm ghcr.io/goated-geese/yolks:dotnet_10 dotnet --version
```

## Build locally

From the variant folder:

```bash
cd dotnet/10
docker build -t ghcr.io/goated-geese/yolks:dotnet_10 .
```

Multi-arch (CI currently builds `linux/amd64` only):

```bash
cd dotnet/10
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/goated-geese/yolks:dotnet_10 --push .
```

## Publishing

Pushes to `main` that touch `dotnet/10/**` trigger [`.github/workflows/dotnet-10.yml`](.github/workflows/dotnet-10.yml), which builds with Buildx and pushes to GHCR using the workflow's `GITHUB_TOKEN`.

The repo must allow **Settings -> Actions -> General -> Workflow permissions -> Read and write** for `packages: write` to succeed.

## Use with Pelican

Add the image URI under the egg's **Docker images** list (Pelican docs: [Creating a Custom Egg](https://pelican.dev/docs/eggs/creating-a-custom-egg)):

```text
ghcr.io/goated-geese/yolks:dotnet_10
```

If the GHCR package is private, configure pull credentials on each Wings node (`docker login ghcr.io`) or set the package visibility to public under [Goated-Geese packages](https://github.com/orgs/Goated-Geese/packages).

## Adding a new yolk

1. Create `<family>/<version>/Dockerfile` plus an `entrypoint.sh` per the [Pelican custom yolk guide](https://pelican.dev/docs/eggs/creating-a-custom-yolk).
2. Add a workflow under `.github/workflows/<family>-<version>.yml` modeled on `dotnet-10.yml`.
3. Document the new tag in the table above.
