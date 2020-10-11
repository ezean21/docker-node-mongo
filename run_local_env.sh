#!/usr/bin/env bash

set -e

# Stop minikune
minikube stop
# Start minikube mounting locally code
minikube start --mount-string="$HOME/workspaces/docker-node-mongo:/code"

# Set docker env
eval $(minikube docker-env)

# Build webapp image
docker build -t webapp -f Dockerfile .
# Build js code locally
npm install

# Add biname repo, replace (overwrite) the repo if it already exists
helm repo add bitnami https://charts.bitnami.com/bitnami --force-update

# Delete all helm packages
helm delete mongo webapp

# Install mongo
helm install mongo bitnami/mongodb -f local-mongodb-values.yaml

# Ensure mongo pod is ready
kubectl rollout status deployment.v1.apps/mongo

# Install webapp
helm install webapp charts/webapp

# Ensure webapp pd is ready
kubectl rollout status deployment.v1.apps/webapp

# Starting tunnel for service webapp
minikube service webapp