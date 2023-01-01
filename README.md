# LSC

- `aws` - Terraform config for EC2 instances
- https://github.com/k3s-io/k3s-ansible - Ansible setup for k3s cluster
- `ansible-nomad` - Ansible setup for Nomad cluster

## Setup

```bash
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

## Nomad jobs
Note actual values in command below should be adapted to your environment,
they serve only as an example.

1. Create small cluster of ec2 machines:
  
   Prepare your aws credentials: 
   ```bash
   export AWS_PROFILE=lsc
   ```
   
   To initialize terraform, run:
   ```bash
   terraform init
   ```
   
   To see what resources will be created, run:
   ```bash
   terraform plan
   ```
   
   To deploy the cluster. 
   Note that there are a couple of variables that can be specified, see `main.tf`.
   ```bash
   terraform apply
   ```
   
   To take down the cluster, run:
   ```bash
   terraform destroy
   ```
   
2. Ssh into master-machine:
   ```bash
      ssh -i "labuser.pem" ubuntu@ec2-3-238-53-103.compute-1.amazonaws.com
   ```
3. Deploy nomad on top of the deployed cluster:
   Check if connecting to master machine is possible:
   ```bash
   ansible master -m command --args "ls -l"
   ```
   Check if workers are up and running:
   ```bash
   ansible workers -m ping
   ```
   