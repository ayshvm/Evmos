# Deploying EVMOS Testnet Node on GKE Clusters

This guide outlines the steps to deploy an EVMOS testnet node on Google Kubernetes Engine (GKE) clusters using Terraform for infrastructure provisioning and ArgoCD for GitOps-based deployment. The setup includes creating two GKE clusters with network configurations, a bastion host for accessing the private cluster, and deploying the EVMOS node using Helm charts.


# Prerequisites
Before starting the deployment process, ensure you have the following prerequisites:

Google Cloud Platform (GCP) Account:

Access to GCP Console with the necessary permissions to create GKE clusters, configure networking, and manage resources.

Installed Tools:
- Helm: The package manager for Kubernetes.
- kubectl: The Kubernetes command-line tool.
- ArgoCD CLI: The command-line interface for ArgoCD.

# Step 1: Infrastructure Setup with Terraform

- Create GKE Clusters
  - Use Terraform to provision two GKE clusters: one public and one private. Configure network settings, subnets, NAT, and a Cloud Router for communication.

- Bastion Host Configuration
  - Set up a bastion host to access the private GKE cluster securely. Ensure proper firewall rules for secure communication.

- Why Terraform?
  - Terraform is chosen for its infrastructure as code (IaC) capabilities, enabling reproducibility, version control, and ease of management for infrastructure components.

```bash
Authenticate with gcloud and update terraform provider with correct project 

# Run terraform to Deploy Networking and GKE
cd gcp/gke
terraform init ;  terraform plan ;  terraform apply 
```

# Step 2: EVMOS Docker Image and Helm Chart

- Docker Image
  - Create an EVMOS Docker image and push it to Docker Hub for accessibility.

```bash
cd docker/evmos
docker build -t evmos .
docker push docker.io/<account>/evmos:<tag>
```

- Helm Chart
 -  Develop a Helm chart to deploy the EVMOS node using Polkachu snapshot and seeds.


# Step 3: GitOps Deployment with ArgoCD

- Deploy ArgoCD
  - Install ArgoCD on the public GKE cluster, providing a GitOps approach for managing Kubernetes resources.

- Add Private Cluster to ArgoCD
  - Use the bastion host to securely connect the private GKE cluster to ArgoCD, allowing centralized management.

- Helm Chart Sync
  - Sync the Helm chart repository from a GitHub repository to ArgoCD. This connects the Helm chart for EVMOS deployment to the private GKE cluster.

```bash

# connect to public gke cluster
gcloud auth login 
gcloud container clusters get-credentials <public cluster> --zone us-central1-a --project <gcp project>

# install argocd 
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# connect to bastion host and connect to public cluster and login argo
gcloud container clusters get-credentials <public cluster> --zone us-central1-a --project <gcp project>
argocd login <argo url>

# connect to argocd and connect it private cluster on bastion
gcloud container clusters get-credentials <private cluster> --zone us-central1-a --project <gcp project>
argocd cluster add <private cluster config>

# add repository to argo which holds helm chart
argocd repo add https://github.com/ayushvtf/Evmos --username <user> --password <token>

```

# Step 4: Deploy EVMOS Node and Expose Endpoints

- Sync Helm Chart in ArgoCD
  - Trigger the synchronization of the Helm chart in ArgoCD to deploy the EVMOS node to the private GKE cluster.

- Expose Endpoints
  -  Use a GCE Load Balancer to expose the RPC, P2P, and Prometheus endpoints of the EVMOS node securely.

```bash
# continue on bastion, deploy project and application to public cluster which will use argo to deploy to private cluster
cd argo/evmos
kubectl apply -f project.yaml
kubectl apply -f application.yaml

# verify node is synced on argo UI
```

# Step 5: Monitoring Setup with Prometheus and Grafana

- Deploy Prometheus and Grafana
  - On the public GKE cluster, deploy Prometheus and Grafana for monitoring purposes.

- Configure Prometheus as Data Source
  - Connect Grafana to Prometheus as a data source to collect metrics.

- Monitoring Dashboard
  - Scrape Prometheus metrics from the EVMOS node in the private cluster and create a comprehensive monitoring dashboard in Grafana.


```bash

# connect to public gke cluster
gcloud auth login 
gcloud container clusters get-credentials <public cluster> --zone us-central1-a --project <gcp project>

# install prometheus and grafana
helm install grafana grafana/grafana  -n monitoring  
helm install grafana grafana/grafana  -n monitoring

# update grafana to add prometheus as data source
# update prometheus configmap to scrape the evmos prometheus

- job_name: evmos-testnet
  static_configs:
  - targets:
    - <evmos node endpoint>:26660

# verify on grafana with job and create dashboard using evmos node metrics
```
