# Terraform AWS CLI Docker Image

Minimal and lightweight Docker image combining **Terraform** and **AWS CLI** with zero compatibility issues.

Built to solve the Alpine Linux + Python 3.12 + pyexpat incompatibility that breaks aws-cli in `hashicorp/terraform:1.10.3`.

## Features

✅ **Terraform 1.10.3** - Latest stable version  
✅ **AWS CLI v2** - Works perfectly (glibc-based, no pyexpat errors)  
✅ **jq** - JSON query tool included  
✅ **Optimized** - Single RUN layer, minimal footprint (~400MB)  
✅ **Production-ready** - Used in PSKR CI/CD pipelines  

## Supported Versions

| Component | Version |
|-----------|---------|
| Terraform | 1.10.3 |
| AWS CLI | 2.x latest |
| Python | 3.12 |
| Base Image | Debian 12 slim |

## Quick Start

### Pull the image

```bash
docker pull fspskr/terraform-aws-cli:1.10.3
```

### Run locally

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -e AWS_PROFILE=default \
  fspskr/terraform-aws-cli:1.10.3 \
  sh
```

### Verify installation

```bash
docker run --rm fspskr/terraform-aws-cli:1.10.3 sh -c \
  'terraform version && aws --version && jq --version'
```

## Build from source

```bash
# Clone this repository
git clone https://github.com/pskr-io/terraform-aws-cli.git
cd terraform-aws-cli

# Build with default Terraform version (1.10.3)
docker build -t terraform-aws-cli:1.10.3 .

# Or build with custom Terraform version
docker build --build-arg TF_VERSION=1.10.2 -t terraform-aws-cli:1.10.2 .
```

## Environment Variables

When running the container, you can pass AWS credentials:

```bash
docker run -it --rm \
  -e AWS_ACCESS_KEY_ID=your-key \
  -e AWS_SECRET_ACCESS_KEY=your-secret \
  -e AWS_REGION=sa-east-1 \
  -v $(pwd):/workspace \
  fspskr/terraform-aws-cli:1.10.3 \
  sh
```

Or use AWS profile from local credentials:

```bash
docker run -it --rm \
  -e AWS_PROFILE=production \
  -v ~/.aws:/root/.aws:ro \
  -v $(pwd):/workspace \
  fspskr/terraform-aws-cli:1.10.3 \
  sh
```

## CI/CD Integration

### GitLab CI

```yaml
.terraform-base:
  image: fspskr/terraform-aws-cli:1.10.3
  script:
    - terraform init
    - terraform plan
```

### GitHub Actions

```yaml
container:
  image: fspskr/terraform-aws-cli:1.10.3
steps:
  - run: terraform init
  - run: terraform plan
```

## Why this image?

### Problem

The official `hashicorp/terraform:1.10.3` image (Alpine Linux) has a critical incompatibility:

```
ImportError: Error relocating /usr/lib/python3.12/lib-dynload/pyexpat.cpython-312-x86_64-linux-musl.so:
XML_SetAllocTrackerActivationThreshold: symbol not found
```

This breaks any CI/CD pipeline that needs both Terraform and AWS CLI.

**Root cause:** Alpine uses musl libc, but aws-cli's pyexpat module expects glibc.

### Solution

This image uses `python:3.12-slim` (Debian-based with glibc) instead of Alpine, solving the incompatibility while keeping the image lightweight.

## Comparison

| Image | Size | aws-cli | Terraform | Compatible |
|-------|------|---------|-----------|------------|
| `hashicorp/terraform:1.10.3` | 200MB | ✗ (pyexpat error) | 1.10.3 | No |
| `zenika/terraform-aws-cli:latest` | 300MB | ✓ | 1.6.5 | Yes |
| `fspskr/terraform-aws-cli:1.10.3` | 400MB | ✓ | 1.10.3 | Yes |

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! To add a new Terraform version:

1. Test locally: `docker build --build-arg TF_VERSION=x.y.z .`
2. Update `supported_versions.json`
3. Submit a pull request

## Support

- 📧 For issues: Open an issue on GitHub
- 🐳 Image available at: https://hub.docker.com/r/fspskr/terraform-aws-cli
- 📚 Terraform docs: https://www.terraform.io/docs
- 🔧 AWS CLI docs: https://docs.aws.amazon.com/cli/

## Acknowledgments

- Inspired by [Zenika terraform-aws-cli](https://github.com/zenika-open-source/terraform-aws-cli)
- HashiCorp for Terraform
- AWS for AWS CLI
