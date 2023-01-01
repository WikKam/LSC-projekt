# LSC

- `aws` - Terraform config for EC2 instances
- https://github.com/k3s-io/k3s-ansible - Ansible setup for k3s cluster
- `ansible-nomad` - Ansible setup for Nomad cluster

## Setup

```bash
git submodule update --init --recursive
```

## Blender job
There exists [petroniuss/lcs-blender:latest](https://hub.docker.com/repository/docker/petroniuss/lcs-blender)
docker image that can be used to run blender jobs.

Usage:
```bash
docker run petroniuss/lcs-blender:latest \
   --background myfile.blend \
   -E CYCLES \
   --render-output ./frame-1.png \
   --render-frame 1
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
   
2. SSH into master-machine, just to see what's going on:
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
   
   Deploy nomad, remember about updating hosts.ini file:
   ```bash
   ansible-playbook site.yml
   ```

   Nomad UI should be available at: `http://<master-ip>:4646`
   ```bash
   open "http://$(terraform output -raw master_public_ip):4646"
   ```

4. Configure nomad client.
   
   Set nomad master server address for nomad client:
   ```bash
   export NOMAD_ADDR="http://$(terraform output -raw master_public_ip):4646"
   ```
   
   See if nomad nodes are up and running:
   ```bash
   nomad node status
   ```
   
5. Play with nomad jobs.
   
   To deploy a job, run:
   ```bash
   nomad job run demo-nomad.hcl
   ```

   To see job status, run:
   ```bash
   nomad job status demo-nomad
   ```

   To see allocation logs, run:
   ```bash
   nomad alloc logs df69c3b0
   ```
   
6. Run blender job.

   Change `count` in `blender-render-nomad.hcl` to desired number of jobs.
   ```bash
   nomad job run blender-render-nomad.hcl
   ```
   Head to consul UI to watch the progress of these jobs.





