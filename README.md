[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/ddev/ddev-minio/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ddev/ddev-minio/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-minio)](https://github.com/ddev/ddev-minio/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-minio)](https://github.com/ddev/ddev-minio/releases/latest)

# DDEV MinIO

## Overview

[MinIO](https://min.io/) is an object storage system. It is API compatible with the Amazon S3 cloud storage service. It is capable of working with unstructured data such as photos, videos, log files, backups, and container images with the maximum supported object size being 50TB.

This add-on integrates MinIO into your [DDEV](https://ddev.com/) project.

## Installation

```sh
ddev add-on get ddev/ddev-minio
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev minio` | Open MinIO console in your browser (`https://<project>.ddev.site:9090`) |
| `ddev mc` | Run MinIO admin client |
| `ddev logs -s minio` | Check MinIO logs |

### MinIO console credentials

| Field    | Value       |
|----------|-------------|
| Username | `ddevminio` |
| Password | `ddevminio` |

### File access

Project docker instances can access MinIO API via `http://minio:10101`

DDEV router is configured to proxy the requests to `https://<project>.ddev.site:10101` to MinIO S3 API.

Example URLs for accessing files are

| Bucket   | File path              | Internal URL                                     | External URL                                                    |
|----------|------------------------|--------------------------------------------------|-----------------------------------------------------------------|
| `photos` | `vacation/seaside.jpg` | `http://minio:10101/photos/vacation/seaside.jpg` | `https://<project>.ddev.site:10101/photos/vacation/seaside.jpg` |
| `music`  | `tron/derezzed.mp3`    | `http://minio:10101/music/tron/derezzed.mp3`     | `https://<project>.ddev.site:10101/music/tron/derezzed.mp3`     |

## Connecting from PHP

### Installation

Since MinIO is S3 compatible you can use [AWS PHP SDK](https://packagist.org/packages/aws/aws-sdk-php). Install it with composer:

```bash
ddev composer require aws/aws-sdk-php
```

### Basic usage

```php
<?php

require __DIR__ . '/vendor/autoload.php';

$s3 = new \Aws\S3\S3Client([
    'endpoint' => 'http://minio:10101',
    'credentials' => [
        'key' => 'ddevminio',
        'secret' => 'ddevminio',
    ],
    'region' => 'us-east-1',
    'version' => 'latest',
    'use_path_style_endpoint' => true,
]);

$bucketName = 'ddev-minio';

if (!$s3->doesBucketExist($bucketName)) {
    $s3->createBucket([
        'Bucket' => $bucketName,
    ]);
}

$s3->putObject([
    'Bucket' => $bucketName,
    'Key' => 'ddev-test',
    'Body' => 'DDEV Minio is working!',
]);

$object = $s3->getObject([
    'Bucket' => $bucketName,
    'Key' => 'ddev-test',
]);

echo $object['Body'];
```

## Advanced Customization

To change the Docker image:

```bash
ddev dotenv set .ddev/.env.minio --minio-docker-image=minio/minio:latest
ddev add-on get ddev/ddev-minio
ddev restart
```

You can modify `.ddev/docker-compose.minio.yaml` directly by removing the `#ddev-generated` line, but it's recommended to use a separate `.ddev/docker-compose.minio_extra.yaml` file for overrides, for example:

```yaml
services:
  minio:
    command: server --console-address :9090 --address :10101

configs:
  mc-config.json:
    content: |
      {
        "version": "10",
        "aliases": {
          "minio": {
            "url": "http://localhost:10101",
            "accessKey": "ddevminio",
            "secretKey": "ddevminio",
            "api": "s3v4",
            "path": "auto"
          }
        }
      }
```

## Credits

**Developed and maintained by [Oblak Studio](https://github.com/oblakstudio)**
