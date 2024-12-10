# Self hosting

## Introduction
This repository contains the docker-compose file to start the localstack and the services required for the athina to run.

## Prerequisites
- git
- Docker
- docker-compose

## Setup
For building the docker images of the required services run the following commands.
    
```bash
git clone <this-repo>
cd athina-deploy
docker-compose build
```

Secrets and environment variables should be added to the `.env` file in the root directory of the project. You can copy the example env file and update the values accordingly. 

```bash
cp .env.example .env
# set the right values in .env
# Note: If you are using an existing db make sure that you follow the instructions in the .env file
```

You can start localstack using the following command also. This will be where worker will be running. The script includes commands for start/stop/status of localstack.

```bash
bash localstack.sh start
```

Once the localstack is up and running, you can deploy the workers into it using the following command. Please note that the provider should be set to `localstack` in the `.env` file of workers repository. 

Once the workers are deployed, you will be provided with the endpoint to trigger them. Note it and update the `LAMBDA_TRIGGER_WORKER_FUNCTION_URL` in the `.env` file in this repository. Note that the URL should be ending with `/trigger-job-workers` (if not you should update the URL accordingly).

```bash
# cd into the worker directory
serverless deploy --stage local --config serverless-localstack.yml
```

You can start the services each service using the following commands. You can pick the services that you want to start and run those commands alone as well.

```bash
# Prompt database and API service
docker-compose up -d prompt_db api

# Jobs database and Scheduler service
docker-compose up -d jobs_db scheduler

# Analytics database and Analytics service
docker-compose up -d analytics_db analytics

# Dashboard
docker-compose up -d dashboard
```

## Docker Registry (ECR)
The docker images of the services are pushed to the ECR. The images are pulled from the ECR in the deployment process. Following are few commands around that

```bash
# Login to the ECR
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 867387325299.dkr.ecr.eu-central-1.amazonaws.com

# Build and tag the images
docker-compose build

# Push the images to the ECR
docker-compose push

# Pull the images from the ECR
docker-compose pull
```

## For viewing and searching container logs

# Dozzle
The dozzle service is provided for you to view the logs of the services. 

> ⚠️ **Security Note**: Dozzle requires read-only access to the Docker socket to function. 
> While configured with read-only access, this still allows the service to read information 
> about all containers, their configurations, and logs.
For setting up the dozzle service, you can create the `dozzle-users.yml` file and update the values accordingly.
```bash
# Generate the file content with
docker run amir20/dozzle generate --name Admin --email me@email.net --password secret logs_admin
```

Sample output
```yml
users:
  # "logs_admin" here is username
  logs_admin:
    email: me@email.net
    name: Admin
    # Generated with docker run amir20/dozzle generate --name Admin --email me@email.net --password secret logs_admin
    password: <password>
```

You can start the dozzle service using the following command (make sure the dozzle env variables are set):

Required environment variables:
- `DOZZLE_PORT`: The port to expose the Dozzle web interface (e.g., 9001)
- `DOZZLE_USERNAME`: Username for authentication
- `DOZZLE_PASSWORD`: Password for authentication
 
 ```bash
 docker-compose up -d dozzle
```bash
docker-compose up -d dozzle
```
