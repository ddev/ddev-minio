<div align="center">

# ddev-minio - use MinIO object storage in DDEV

![GitHub release (with filter)](https://img.shields.io/github/v/release/oblakstudio/ddev-minio)
[![E2E Tests](https://github.com/oblakstudio/ddev-minio/actions/workflows/cron_tests.yml/badge.svg?event=schedule)](https://github.com/oblakstudio/ddev-minio/actions/workflows/tests.yml)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

</div>

This repository provides MinIO add-on to [DDEV](https://ddev.readthedocs.io).

It's based on [MinIO official image](https://hub.docker.com/r/minio/minio) and [DDEV custom compose files](https://ddev.readthedocs.io/en/stable/users/extend/custom-compose-files/)

## Configuration

### MinIO bucket

Login to MinIO console `https://<project>.ddev.site:9090` login with credentials `ddevminio:ddevminio` and create a bucket.

### Composer package

Your project will most likely require the [AWS PHP SDK](https://packagist.org/packages/aws/aws-sdk-php). You can install it like this

```bash
$ ddev composer require aws/aws-sdk-php
```
Project docker instances can access MinIO api via `http://minio:9000`

### Public access

DDEV Router is configured to proxy the requests to `https://<project>.ddev.site:9000` to MinIO S3 Api.

## Commands

Addon exposes the following commands

| Command | Usage        | Description                     |
|---------|--------------|---------------------------------|
| `minio` | `ddev minio` | Launches the MinIO Console      |
| `mc`    | `ddev mc`    | Launches the MinIo admin client |

___

**Based on the original [ddev-contrib recipe](https://github.com/ddev/ddev-contrib/tree/master/docker-compose-services/mongodb)**  
**Developed and maintained by [Oblak Studio](https://github.com/oblakstudio)**

