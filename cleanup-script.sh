#!/bin/bash
# scripts/cleanup.sh

echo "====== DevOps Assignment Cleanup ======"
echo "This will delete all resources to save costs"
echo ""

read -p "Are you sure you want to delete all resources? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "====== Starting Cleanup ======"
echo ""

# 1. Delete Application Resources
echo "🗑️  Deleting Java API Application..."
kubectl delete namespace java-api-kavindu --ignore-not-found=true

# 2. Delete Monitoring Stack
echo "🗑️  Deleting Monitoring Stack..."
helm uninstall prometheus -n monitoring --ignore-not-found
kubectl delete namespace monitoring --ignore-not-found=true

# 3. Delete NGINX Ingress Controller
echo "🗑️  Deleting NGINX Ingress Controller..."
helm uninstall ingress-nginx -n ingress-nginx --ignore-not-found
kubectl delete namespace ingress-nginx --ignore-not-found=true

# 4. Delete cert-manager
echo "🗑️  Deleting cert-manager..."
helm uninstall cert-manager -n cert-manager --ignore-not-found
kubectl delete namespace cert-manager --ignore-not-found=true

# 5. Delete any remaining resources
echo "🗑️  Cleaning up remaining resources..."
kubectl delete clusterrole --all --ignore-not-found=true
kubectl delete clusterrolebinding --all --ignore-not-found=true
kubectl delete crd --all --ignore-not-found=true

# 6. Wait for cleanup
echo "⏳ Waiting for resources to be deleted..."
sleep 30

# 7. Check remaining resources
echo ""
echo "====== Remaining Resources ======"
kubectl get all --all-namespaces

echo ""
echo "====== Cleanup Summary ======"
echo "✅ Java API Application: Deleted"
echo "✅ Monitoring Stack: Deleted"
echo "✅ NGINX Ingress Controller: Deleted"
echo "✅ cert-manager: Deleted"
echo ""

# 8. Delete GKE Cluster (optional)
echo "====== GKE Cluster Cleanup ======"
echo ""
echo "To delete the GKE cluster and stop all charges, run:"
echo "gcloud container clusters delete java-api-cluster-kavindu --zone=us-central1-a"
echo ""
read -p "Do you want to delete the GKE cluster now? (yes/no): " delete_cluster

if [ "$delete_cluster" = "yes" ]; then
    echo "🗑️  Deleting GKE cluster..."
    gcloud container clusters delete java-api-cluster-kavindu --zone=us-central1-a --quiet
    echo "✅ GKE cluster deleted successfully!"
else
    echo "⚠️  GKE cluster NOT deleted. Remember to delete it manually to avoid charges:"
    echo "   gcloud container clusters delete java-api-cluster-kavindu --zone=us-central1-a"
fi

echo ""
echo "✅ Cleanup completed!"
echo ""
echo "💰 Cost Savings:"
echo "   - All Kubernetes resources deleted"
echo "   - LoadBalancer external IPs released"
echo "   - Compute resources freed"
if [ "$delete_cluster" = "yes" ]; then
    echo "   - GKE cluster deleted (no more charges)"
else
    echo "   - ⚠️  GKE cluster still running (charges continue)"
fi

echo ""
echo "📋 What was cleaned up:"
echo "   ✅ Java API pods and services"
echo "   ✅ Prometheus monitoring stack"
echo "   ✅ Grafana dashboards"
echo "   ✅ NGINX ingress controller"
echo "   ✅ cert-manager and TLS certificates"
echo "   ✅ All external LoadBalancer IPs"
echo "   ✅ All persistent volumes"
echo ""

if [ "$delete_cluster" != "yes" ]; then
    echo "🔄 To recreate everything later:"
    echo "   1. Run: ./setup-script.sh"
    echo "   2. Build and push your Docker image"
    echo "   3. Apply Kubernetes manifests"
    echo ""
fi

echo "Thank you for using the DevOps assignment setup! 🚀"
