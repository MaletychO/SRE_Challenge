# Nginx Deployment Troubleshooting and Solution

## Issue Summary
The initial `nginx.yaml` file had several issues:
1. **Service Selector Mismatch**: The Service was not correctly selecting the Pods due to a label mismatch.
2. **High Resource Requests and Limits**: The Deployment had high CPU requests and limits which could cause scheduling issues on a local cluster like Minikube.
3. **Node Affinity Configuration**: The Deployment had node affinity that could prevent pod scheduling on nodes without specific labels.

## Actions Taken
1. **Fixed the Service Selector**: Updated the Service selector to match the Deployment labels.
2. **Adjusted Resource Requests and Limits**: Reduced the CPU requests and limits to values more appropriate for local development.
3. **Removed Node Affinity**: Removed node affinity settings to allow the pod to be scheduled on any node.

## Commands Used
- Applied the deployment and service configuration:
  ```bash
  kubectl apply -f nginx.yaml

- Verified the status of the deployment and services:

```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

- Accessed the Nginx web server in the browser using:

```bash
minikube service sretest-service --url
```