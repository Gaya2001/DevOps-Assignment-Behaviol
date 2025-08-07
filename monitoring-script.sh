#!/bin/bash
# scripts/monitor.sh

echo "====== Java API Monitoring ======"
echo "Namespace: java-api-kavindu"
echo

echo "Pods Status:"
kubectl get pods -n java-api-kavindu

echo -e "\nService Status:"
kubectl get svc -n java-api-kavindu

echo -e "\nIngress Status:"
kubectl get ingress -n java-api-kavindu

echo -e "\nHPA Status:"
kubectl get hpa -n java-api-kavindu

echo -e "\nCertificates Status:"
kubectl get certificates -n java-api-kavindu

echo -e "\nRecent Events:"
kubectl get events -n java-api-kavindu --sort-by='.lastTimestamp' | tail -10

echo -e "\n====== Monitoring Stack ======"
echo "Namespace: monitoring"
echo

echo "Monitoring Pods:"
kubectl get pods -n monitoring

echo -e "\nMonitoring Services:"
kubectl get svc -n monitoring | grep -E "(prometheus|grafana)"

echo -e "\n====== Infrastructure ======"
echo

echo "NGINX Ingress Controller:"
kubectl get pods -n ingress-nginx

echo -e "\nCert-Manager:"
kubectl get pods -n cert-manager

echo -e "\n====== Access URLs ======"
echo

API_IP=$(kubectl get svc java-api-service -n java-api-kavindu -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
INGRESS_IP=$(kubectl get ingress java-api-ingress -n java-api-kavindu -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
PROMETHEUS_IP=$(kubectl get svc prometheus-kube-prometheus-prometheus -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
GRAFANA_IP=$(kubectl get svc prometheus-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)

if [ -n "$API_IP" ]; then
    echo "Java API (LoadBalancer): http://$API_IP:8080/api/users"
fi

if [ -n "$INGRESS_IP" ]; then
    echo "Java API (Domain): https://www.kavinducloudops.tech/api/users"
    echo "Ingress IP: $INGRESS_IP"
fi

if [ -n "$PROMETHEUS_IP" ]; then
    echo "Prometheus: http://$PROMETHEUS_IP:9090"
fi

if [ -n "$GRAFANA_IP" ]; then
    echo "Grafana: http://$GRAFANA_IP (admin/admin123)"
fi

echo -e "\n====== DNS Check ======"
nslookup www.kavinducloudops.tech 8.8.8.8

echo -e "\n====== Quick Commands ======"
echo "View logs: kubectl logs -f deployment/java-api-deployment -n java-api-kavindu"
echo "Scale app: kubectl scale deployment java-api-deployment --replicas=3 -n java-api-kavindu"
echo "Port forward API: kubectl port-forward svc/java-api-service -n java-api-kavindu 8080:8080"
echo "Port forward Grafana: kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80"
