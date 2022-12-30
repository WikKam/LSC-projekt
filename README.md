# LSC

- `aws` - Terraform config for EC2 instances
- https://github.com/k3s-io/k3s-ansible - Ansible setup for k3s cluster
- `ansible-nomad` - Ansible setup for Nomad cluster

## Setup

```bash
# download submodules after cloning
git submodule update --init --recursive
```

## Kubernetes jobs

In order to run Kubernetes jobs locally, do the following:
- Build the image:
```
docker build -t blender-job ./image
```
- Push the image to your local minikube instance:
```
minikube image load blender-job
```
Schedule the jobs:
```
kubectl apply -f kubernetes-job/blender-render.yaml
```
