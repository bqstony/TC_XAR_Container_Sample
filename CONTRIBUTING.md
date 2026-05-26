# CONTRIBUTING

## Push image to ghcr

1. Create GitHub Personal Access Token (PAT) with permissions: write:packages, read:packages
2. Login to GitHub
```bash
export CR_PAT="DEIN_TOKEN"
echo $CR_PAT | docker login ghcr.io -u bqstony --password-stdin
```
3. Push image `make push-image IMAGE_TAG=2026.05.26`
