<!DOCTYPE html>
<html>
<head>
  <title>DevOps Assignment - Java API on GKE</title>
</head>
<body>

<h1>Java Spring Boot REST API on GKE with TLS and Monitoring</h1>

<h2>Project Structure</h2>
<p>The <code>k8s/</code> folder contains all Kubernetes manifests:</p>
<ul>
  <li>01-namespace.yaml</li>
  <li>02-configmap.yaml</li>
  <li>03-deployment.yaml</li>
  <li>04-secret.yaml</li>
  <li>05-service.yaml</li>
  <li>06-hpa.yaml</li>
  <li>07-ingress.yaml</li>
  <li>08-certificate.yaml</li>
  <li>cluster-issuer.yaml</li>
</ul>

<h2>1. Containerization</h2>
<ul>
  <li>Java Spring Boot REST API</li>
  <li>Packaged into a Docker image</li>
  <li>Pushed to Google Artifact Registry</li>
  <li>Example image: <code>us-central1-docker.pkg.dev/betbazar-ops/java-api-repo-kavindu/springboot-restapi-kavindu</code></li>
</ul>

<h2>2. Namespace</h2>
<pre>
kubectl apply -f k8s/01-namespace.yaml
</pre>

<h2>3. ConfigMap</h2>
<pre>
kubectl apply -f k8s/02-configmap.yaml
</pre>

<h2>4. Secret</h2>
<pre>
kubectl apply -f k8s/04-secret.yaml
</pre>

<h2>5. Deployment</h2>
<pre>
kubectl apply -f k8s/03-deployment.yaml
</pre>

<h2>6. Service</h2>
<pre>
kubectl apply -f k8s/05-service.yaml
</pre>

<h2>7. Horizontal Pod Autoscaler (HPA)</h2>
<pre>
kubectl apply -f k8s/06-hpa.yaml
</pre>

<h2>8. NGINX Ingress Controller</h2>
<p>Installed via Helm:</p>
<pre>
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install nginx-private bitnami/nginx-ingress-controller \
  --namespace nginx-private \
  --create-namespace \
  --set ingressClassResource.name=nginx-private \
  --set controller.ingressClass=nginx-private \
  --set ingressClassResource.enabled=true \
  --set ingressClassResource.default=false
</pre>

<h2>9. TLS Setup</h2>

<h3>Install cert-manager</h3>
<pre>
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
</pre>

<h3>ClusterIssuer</h3>
<pre>
kubectl apply -f k8s/cluster-issuer.yaml
</pre>

<h3>Certificate</h3>
<pre>
kubectl apply -f k8s/08-certificate.yaml
</pre>

<h2>10. Ingress Resource</h2>
<p>Configured for HTTPS using TLS certificate:</p>
<pre>
kubectl apply -f k8s/07-ingress.yaml
</pre>

<h2>11. Monitoring (Prometheus + Grafana)</h2>
<pre>
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
</pre>

<h3>Access Grafana</h3>
<pre>
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
</pre>
<p>Login to <code>http://localhost:3000</code> with admin credentials.</p>

<h2>12. Domain and DNS</h2>
<ul>
  <li>Custom domain: <code>www.kavinducloudops.tech</code></li>
  <li>A record points to Ingress external IP: <code>35.224.125.190</code></li>
</ul>

<h2>13. Final Validation</h2>
<ul>
  <li><code>kubectl get ingress -n nginx-private</code> - shows ingress IP</li>
  <li><code>kubectl get certificate -n nginx-private</code> - cert status</li>
  <li><code>kubectl get secret java-api-tls-secret -n nginx-private</code></li>
  <li>Visit: <a href="https://www.kavinducloudops.tech">https://www.kavinducloudops.tech</a></li>
</ul>

<h2>14. Summary</h2>
<p>This setup delivers a fully containerized, auto-scaled, TLS-secured Java API with observability — deployed on GKE using Kubernetes and Helm.</p>

</body>
</html>
