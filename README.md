<div align="center">

# ddev-minio - use MinIO object storage in DDEV

![GitHub release (with filter)](https://img.shields.io/github/v/release/oblakstudio/ddev-minio)
[![Daily tests](https://github.com/oblakstudio/ddev-minio/actions/workflows/cron_tests.yml/badge.svg)](https://github.com/oblakstudio/ddev-minio/actions/workflows/cron_tests.yml)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

</div>

This repository provides MinIO add-on to [DDEV](https://ddev.readthedocs.io).

It's based on [MinIO official image](https://hub.docker.com/r/minio/minio) and [DDEV custom compose files](https://ddev.readthedocs.io/en/stable/users/extend/custom-compose-files/)

## Configuration

### MinIO console

Login to MinIO console `https://<project>.ddev.site:9090` login with credentials `ddevminio:ddevminio` and create a bucket.

### File access

Project docker instances can access MinIO api via `http://minio:10101`

DDEV Router is configured to proxy the requests to `https://<project>.ddev.site:10101` to MinIO S3 Api.

Example URLs for accessing files are

| Bucket   | File path              | Internal URL                                     | External URL                                                    |
|----------|------------------------|--------------------------------------------------|-----------------------------------------------------------------|
| `photos` | `vacation/seaside.jpg` | `http://minio:10101/photos/vacation/seaside.jpg` | `https://<project>.ddev.site:10101/photos/vacation/seaside.jpg` |
| `music`  | `tron/derezzed.mp3`    | `http://minio:10101/music/tron/derezzed.mp3`     | `https://<project>.ddev.site:10101/music/tron/derezzed.mp3`     |

## Connecting from PHP

### Installation

Since MinIO is S3 compatible you can use [AWS PHP SDK](https://packagist.org/packages/aws/aws-sdk-php). Install it with composer:

```bash
$ ddev composer require aws/aws-sdk-php
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

## Commands

Addon exposes the following commands

| Command | Usage        | Description                     |
|---------|--------------|---------------------------------|
| `minio` | `ddev minio` | Launches the MinIO Console      |
| `mc`    | `ddev mc`    | Launches the MinIo admin client |

___

**Based on the original [ddev-contrib recipe](https://github.com/ddev/ddev-contrib/tree/master/docker-compose-services/mongodb)**  
**Developed and maintained by [Oblak Studio](https://github.com/oblakstudio)**

