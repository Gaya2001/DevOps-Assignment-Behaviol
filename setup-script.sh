#!/bin/bash

# Complete DevOps Assignment Setup Script
# Run this after creating your GKE cluster

# Ensure kubectl is in PATH for bash
export PATH=$PATH:/usr/local/bin:/c/Program\ Files/Google/Cloud\ SDK/google-cloud-sdk/bin

echo "🚀 Starting DevOps Assignment Setup..."

# 1. Add Helm repositories
echo "📦 Adding Helm repositories..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 2. Install NGINX Ingress Controller
echo "🌐 Installing NGINX Ingress Controller..."
helm install ingress-nginx ingress-nginx/ingress-nginx \
    --create-namespace \
    --namespace ingress-nginx \
    --set controller.service.type=LoadBalancer

# 3. Install cert-manager
echo "🔒 Installing cert-manager..."
helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.8.0 \
    --set installCRDs=true

# 4. Install Monitoring Stack (All-in-one)
echo "📊 Installing Prometheus + Grafana monitoring stack..."
helm install prometheus prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --create-namespace \
    --set prometheus.service.type=LoadBalancer \
    --set grafana.service.type=LoadBalancer \
    --set grafana.adminPassword=admin123

# 5. Deploy Application
echo "🚀 Deploying Java API application..."
kubectl apply -f k8s/01-namespace.yaml
kubectl apply -f k8s/02-configmap.yaml
kubectl apply -f k8s/04-secret.yaml
kubectl apply -f k8s/03-deployment.yml
kubectl apply -f k8s/05-service.yaml
kubectl apply -f k8s/06-hpa.yaml

# 6. Wait for ingress controller
echo "⏳ Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# 7. Install TLS and Ingress
echo "🔐 Setting up TLS and ingress..."
kubectl apply -f k8s/cluster-issuer.yaml
kubectl apply -f k8s/08-certificate.yaml
kubectl apply -f k8s/07-ingress.yaml

echo "✅ Setup complete!"
echo ""
echo "🔍 Getting access information..."

# Get external IPs
echo "📋 External IPs:"
echo "Java API Service:"
kubectl get service java-api-service -n java-api-kavindu -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
echo ""
echo "Ingress:"
kubectl get ingress java-api-ingress -n java-api-kavindu -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
echo ""
echo "Prometheus:"
kubectl get service prometheus-kube-prometheus-prometheus -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
echo ""
echo "Grafana:"
kubectl get service prometheus-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
echo ""

echo "🎯 Access URLs:"
echo "API: http://[JAVA-API-IP]:8080/api/users"
echo "Prometheus: http://[PROMETHEUS-IP]:9090"
echo "Grafana: http://[GRAFANA-IP]:3000 (admin/admin123)"
echo ""
echo "⚠️  Note: Configure DNS to point your domain to the ingress IP for HTTPS access"
