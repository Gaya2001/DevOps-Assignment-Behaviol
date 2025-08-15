# Complete DevOps Assignment Setup Script (PowerShell)
# Run this after creating your GKE cluster and connecting with gcloud

Write-Host "Starting DevOps Assignment Setup..." -ForegroundColor Green

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Cyan
try {
    $clusterInfo = kubectl cluster-info 2>$null
    if ($clusterInfo) {
        Write-Host "Kubernetes cluster is reachable" -ForegroundColor Green
    } else {
        Write-Host "Kubernetes cluster not reachable. Please connect to your GKE cluster first." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "kubectl not found or cluster not reachable" -ForegroundColor Red
    exit 1
}

# 1. Add Helm repositories
Write-Host "Adding Helm repositories..." -ForegroundColor Yellow
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
Write-Host "Helm repositories added and updated" -ForegroundColor Green

# 2. Install NGINX Ingress Controller
Write-Host "Installing NGINX Ingress Controller..." -ForegroundColor Yellow
helm install ingress-nginx ingress-nginx/ingress-nginx `
    --create-namespace `
    --namespace ingress-nginx `
    --set controller.service.type=LoadBalancer
Write-Host "NGINX Ingress Controller installed" -ForegroundColor Green

# 3. Install cert-manager
Write-Host "Installing cert-manager..." -ForegroundColor Yellow
helm install cert-manager jetstack/cert-manager `
    --namespace cert-manager `
    --create-namespace `
    --version v1.8.0 `
    --set installCRDs=true
Write-Host "cert-manager installed" -ForegroundColor Green

# 4. Install Monitoring Stack (Separate Grafana and Prometheus)
Write-Host "Installing monitoring stack..." -ForegroundColor Yellow

# Install Grafana
Write-Host "Installing Grafana..." -ForegroundColor Cyan
helm install grafana grafana/grafana `
    --namespace monitoring `
    --create-namespace `
    --set service.type=LoadBalancer `
    --set adminPassword=admin123
Write-Host "Grafana installed" -ForegroundColor Green

# Install Prometheus
Write-Host "Installing Prometheus..." -ForegroundColor Cyan
helm install prometheus prometheus-community/prometheus `
    --namespace monitoring `
    --set server.service.type=LoadBalancer
Write-Host "Prometheus installed" -ForegroundColor Green

# 5. Deploy Application
Write-Host "Deploying Java API application..." -ForegroundColor Yellow
kubectl apply -f k8s/01-namespace.yaml
kubectl apply -f k8s/02-configmap.yaml
kubectl apply -f k8s/04-secret.yaml
kubectl apply -f k8s/03-deployment.yml
kubectl apply -f k8s/05-service.yaml
kubectl apply -f k8s/06-hpa.yaml
Write-Host "Java API application deployed" -ForegroundColor Green

# 6. Wait for ingress controller
Write-Host "Waiting for ingress controller to be ready..." -ForegroundColor Yellow
kubectl wait --namespace ingress-nginx `
    --for=condition=ready pod `
    --selector=app.kubernetes.io/component=controller `
    --timeout=120s
Write-Host "Ingress controller is ready" -ForegroundColor Green

# 7. Install TLS and Ingress
Write-Host "Setting up TLS and ingress..." -ForegroundColor Yellow
kubectl apply -f k8s/cluster-issuer.yaml
kubectl apply -f k8s/08-certificate.yaml
kubectl apply -f k8s/07-ingress.yaml
Write-Host "TLS and ingress configured" -ForegroundColor Green

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""

# Get external IPs
Write-Host "Getting access information..." -ForegroundColor Cyan
Write-Host ""

# Wait a moment for services to get external IPs
Write-Host "Waiting for LoadBalancer IPs to be assigned..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "External IPs and Access Information:" -ForegroundColor Cyan
Write-Host ""

# Java API Service
Write-Host "Java API Service:" -ForegroundColor Yellow
try {
    $javaApiIp = kubectl get service java-api-service -n java-api-kavindu -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>$null
    if ($javaApiIp) {
        Write-Host "   IP: $javaApiIp" -ForegroundColor White
        Write-Host "   URL: http://$javaApiIp:8080/api/users" -ForegroundColor Green
    } else {
        Write-Host "   IP: Pending..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "   Service not found" -ForegroundColor Red
}

# Ingress
Write-Host ""
Write-Host "Ingress Controller:" -ForegroundColor Yellow
try {
    $ingressIp = kubectl get service ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>$null
    if ($ingressIp) {
        Write-Host "   IP: $ingressIp" -ForegroundColor White
        Write-Host "   HTTP: http://$ingressIp" -ForegroundColor Green
        Write-Host "   HTTPS: https://$ingressIp" -ForegroundColor Green
    } else {
        Write-Host "   IP: Pending..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "   Service not found" -ForegroundColor Red
}

# Prometheus
Write-Host ""
Write-Host "Prometheus:" -ForegroundColor Yellow
try {
    $prometheusIp = kubectl get service prometheus-server -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>$null
    if ($prometheusIp) {
        Write-Host "   IP: $prometheusIp" -ForegroundColor White
        Write-Host "   URL: http://$prometheusIp" -ForegroundColor Green
    } else {
        Write-Host "   IP: Pending..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "   Service not found" -ForegroundColor Red
}

# Grafana
Write-Host ""
Write-Host "Grafana:" -ForegroundColor Yellow
try {
    $grafanaIp = kubectl get service grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>$null
    if ($grafanaIp) {
        Write-Host "   IP: $grafanaIp" -ForegroundColor White
        Write-Host "   URL: http://$grafanaIp" -ForegroundColor Green
        Write-Host "   Username: admin" -ForegroundColor Cyan
        Write-Host "   Password: admin123" -ForegroundColor Cyan
    } else {
        Write-Host "   IP: Pending..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "   Service not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Green
Write-Host "NGINX Ingress Controller - Deployed" -ForegroundColor Green
Write-Host "cert-manager - Deployed" -ForegroundColor Green
Write-Host "Java API Application - Deployed" -ForegroundColor Green
Write-Host "Prometheus - Deployed" -ForegroundColor Green
Write-Host "Grafana - Deployed" -ForegroundColor Green
Write-Host "TLS Certificate - Configured" -ForegroundColor Green
Write-Host "Ingress - Configured" -ForegroundColor Green
Write-Host ""
Write-Host "To connect Grafana to Prometheus:" -ForegroundColor Cyan
Write-Host "   1. Login to Grafana" -ForegroundColor White
Write-Host "   2. Add Prometheus data source with URL: http://prometheus-server.monitoring.svc.cluster.local" -ForegroundColor White
Write-Host ""
Write-Host "Note: Configure DNS to point your domain to the ingress IP for HTTPS access" -ForegroundColor Yellow
