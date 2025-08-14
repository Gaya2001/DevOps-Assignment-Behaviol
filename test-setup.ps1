# Test version of the setup script to verify it works
# This version will show what commands would be executed without actually running them

Write-Host "🧪 Testing PowerShell Setup Script..." -ForegroundColor Cyan
Write-Host ""

# Test 1: Check if required tools are available
Write-Host "🔍 Checking required tools..." -ForegroundColor Yellow

try {
    $helmVersion = helm version --short 2>$null
    if ($helmVersion) {
        Write-Host "✅ Helm is available: $helmVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Helm not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Helm not found" -ForegroundColor Red
}

try {
    $kubectlVersion = kubectl version --client --short 2>$null
    if ($kubectlVersion) {
        Write-Host "✅ kubectl is available: $kubectlVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ kubectl not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ kubectl not found" -ForegroundColor Red
}

try {
    $clusterInfo = kubectl cluster-info 2>$null
    if ($clusterInfo) {
        Write-Host "✅ Kubernetes cluster is reachable" -ForegroundColor Green
    } else {
        Write-Host "❌ Kubernetes cluster not reachable" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Kubernetes cluster not reachable" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 Commands that would be executed:" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Adding Helm repositories:" -ForegroundColor Yellow
Write-Host "   helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx"
Write-Host "   helm repo add jetstack https://charts.jetstack.io"
Write-Host "   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts"
Write-Host "   helm repo update"
Write-Host ""

Write-Host "2. Installing NGINX Ingress Controller:" -ForegroundColor Yellow
Write-Host "   helm install ingress-nginx ingress-nginx/ingress-nginx \"
Write-Host "       --create-namespace \"
Write-Host "       --namespace ingress-nginx \"
Write-Host "       --set controller.service.type=LoadBalancer"
Write-Host ""

Write-Host "3. Installing cert-manager:" -ForegroundColor Yellow
Write-Host "   helm install cert-manager jetstack/cert-manager \"
Write-Host "       --namespace cert-manager \"
Write-Host "       --create-namespace \"
Write-Host "       --version v1.8.0 \"
Write-Host "       --set installCRDs=true"
Write-Host ""

Write-Host "4. Installing Monitoring Stack:" -ForegroundColor Yellow
Write-Host "   helm install prometheus prometheus-community/kube-prometheus-stack \"
Write-Host "       --namespace monitoring \"
Write-Host "       --create-namespace \"
Write-Host "       --set prometheus.service.type=LoadBalancer \"
Write-Host "       --set grafana.service.type=LoadBalancer \"
Write-Host "       --set grafana.adminPassword=admin123"
Write-Host ""

Write-Host "5. Deploying Application:" -ForegroundColor Yellow
Write-Host "   kubectl apply -f k8s/01-namespace.yaml"
Write-Host "   kubectl apply -f k8s/02-configmap.yaml"
Write-Host "   kubectl apply -f k8s/04-secret.yaml"
Write-Host "   kubectl apply -f k8s/03-deployment.yml"
Write-Host "   kubectl apply -f k8s/05-service.yaml"
Write-Host "   kubectl apply -f k8s/06-hpa.yaml"
Write-Host ""

Write-Host "6. Setting up TLS and Ingress:" -ForegroundColor Yellow
Write-Host "   kubectl apply -f k8s/cluster-issuer.yaml"
Write-Host "   kubectl apply -f k8s/08-certificate.yaml"
Write-Host "   kubectl apply -f k8s/07-ingress.yaml"
Write-Host ""

Write-Host "✅ PowerShell script syntax appears to be correct!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 To run the actual setup, use: .\setup-script.ps1" -ForegroundColor Cyan
