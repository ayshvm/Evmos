# Deploying EVMOS Testnet Node on GKE Clusters

This guide outlines the steps to deploy an EVMOS testnet node on Google Kubernetes Engine (GKE) clusters using Terraform for infrastructure provisioning and ArgoCD for GitOps-based deployment. The setup includes creating two GKE clusters with network configurations, a bastion host for accessing the private cluster, and deploying the EVMOS node using Helm charts.


# Prerequisites
Before starting the deployment process, ensure you have the following prerequisites:

Google Cloud Platform (GCP) Account:

Access to GCP Console with the necessary permissions to create GKE clusters, configure networking, and manage resources.

Installed Tools:
Helm: The package manager for Kubernetes.
kubectl: The Kubernetes command-line tool.
ArgoCD CLI: The command-line interface for ArgoCD.

# Step 1: Infrastructure Setup with Terraform

1.1 Create GKE Clusters
Use Terraform to provision two GKE clusters: one public and one private. Configure network settings, subnets, NAT, and a Cloud Router for communication.

1.2 Bastion Host Configuration
Set up a bastion host to access the private GKE cluster securely. Ensure proper firewall rules for secure communication.

1.3 Why Terraform?
Terraform is chosen for its infrastructure as code (IaC) capabilities, enabling reproducibility, version control, and ease of management for infrastructure components.

```bash
Authenticate with gcloud and update terraform provider with correct project 

# Run terraform to Deploy Networking and GKE
cd gcp/gke
terraform init ;  terraform plan ;  terraform apply 
```

# Step 2: EVMOS Docker Image and Helm Chart
2.1 Docker Image
Create an EVMOS Docker image and push it to Docker Hub for accessibility.

2.2 Helm Chart
Develop a Helm chart to deploy the EVMOS node using Polkachu snapshot and seeds.

# Step 3: GitOps Deployment with ArgoCD
3.1 Deploy ArgoCD
Install ArgoCD on the public GKE cluster, providing a GitOps approach for managing Kubernetes resources.

3.2 Add Private Cluster to ArgoCD
Use the bastion host to securely connect the private GKE cluster to ArgoCD, allowing centralized management.

3.3 Helm Chart Sync
Sync the Helm chart repository from a GitHub repository to ArgoCD. This connects the Helm chart for EVMOS deployment to the private GKE cluster.

# Step 4: Deploy EVMOS Node and Expose Endpoints
4.1 Sync Helm Chart in ArgoCD
Trigger the synchronization of the Helm chart in ArgoCD to deploy the EVMOS node to the private GKE cluster.

4.2 Expose Endpoints
Use a GCE Load Balancer to expose the RPC, P2P, and Prometheus endpoints of the EVMOS node securely.

# Step 5: Monitoring Setup with Prometheus and Grafana
5.1 Deploy Prometheus and Grafana
On the public GKE cluster, deploy Prometheus and Grafana for monitoring purposes.

5.2 Configure Prometheus as Data Source
Connect Grafana to Prometheus as a data source to collect metrics.

5.3 Monitoring Dashboard
Scrape Prometheus metrics from the EVMOS node in the private cluster and create a comprehensive monitoring dashboard in Grafana.

