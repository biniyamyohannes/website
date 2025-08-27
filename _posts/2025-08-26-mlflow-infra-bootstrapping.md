---
layout: blogpost
title: "Bootstrapping MLflow with Docker"
date: 2025-08-27
---

This project sets up a containerized MLflow tracking server using Docker.  
The goal is to provide a reproducible and persistent local environment for experiment tracking: an MLflow server with a Postgres backend and S3 artifact storage.

<!-- more -->

## Motivation

A containerized MLflow stack provides a reproducible tracking service that can be reused across future projects.
Postgres and S3 provide persistent artifact storage, and Docker Compose makes the environment easy to spin up or extend.

## Implementation

Key pieces:
- **MLflow server**: logs metrics, parameters, and artifacts.
- **Postgres**: backend database for MLflow metadata.
- **S3**: object storage for artifacts.

All components are defined in [compose.yml](https://github.com/biniyamyohannes/mlops-mlflow-infra/blob/main/docker/compose.yaml). The environment can be started with a single command:

```bash
docker compose up -d
```

The Compose spins up MLflow and Postgres as separate containers. Postgres data is mapped to a named volume for persistence, so experiments aren’t lost when containers stop.

```yaml
postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: mlflow
      POSTGRES_PASSWORD: mlflow_pass
      POSTGRES_DB: mlflow_db
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks: [mlflow]
```

The MLflow tracking server runs on a user-defined Docker network, allowing future containers to connect directly by service name (`mlflow:5000`), without relying on the host or container IP.

```yaml
mlflow:
    build: .
    ports:
      - "5000:5000"
    env_file:
      - .env
    depends_on:
      - postgres
    networks: [mlflow]
    command: >
      mlflow server
      --host 0.0.0.0
      --port 5000
      --default-artifact-root "${S3_ARTIFACT_ROOT}"
      --backend-store-uri postgresql://mlflow:mlflow_pass@postgres:5432/mlflow_db
```

A simple Python script verifies that logging works:

```python
import mlflow

mlflow.set_tracking_uri("http://localhost:5000")

with mlflow.start_run():
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_metric("accuracy", 0.92)
```

[![MLflow Custom Setups](https://img.shields.io/badge/code-GitHub-black?logo=github)](https://github.com/biniyamyohannes/mlops-mlflow-infra)
