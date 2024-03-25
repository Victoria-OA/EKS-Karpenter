
# EKS Cluster with Karpenter Setup

This project demonstrates how to set up an AWS EKS cluster with Karpenter for efficient resource management and autoscaling.

## Prerequisites

- AWS CLI configured with appropriate permissions.
- Terraform installed.
- Helm installed.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/eks-karpenter.git
   ```

2. Change into the project directory:

   ```bash
   cd eks-karpenter
   ```

3. Initialize Terraform:

   ```bash
   terraform init
   ```

4. Create an execution plan:

   ```bash
   terraform plan
   ```

5. Apply the changes to create the EKS cluster:

   ```bash
   terraform apply --auto-approve
   ```

   The EKS cluster will be provisioned.

6. Update the kubeconfig file with the necessary information to access the Amazon EKS cluster:

   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster-name>
   ```

7. Apply all manifest files to deploy the application, expose the service, and configure the ingress:

   ```bash
   kubectl apply -f filename.yaml
   ```

   Since we are using an ingress controller, apply the following commands:

   ```bash
   helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
   helm repo update
   helm install nginx-ingress ingress-nginx/ingress-nginx
   ```

8. Access the application:

   ```bash
   kubectl get svc
   ```

   The application can be accessed using the NodePort or LoadBalancer IP provided by the service.

9. Install Karpenter using Helm:

   ```bash
   helm repo add karpenter https://charts.karpenter.sh
   helm install karpenter karpenter/karpenter
   ```

10. After Karpenter is installed, apply the necessary Karpenter manifest files to configure Karpenter for autoscaling and resource management.

    ```bash
    kubectl apply -f karpenter-config.yaml
    ```
