<!DOCTYPE html>
<html>
<head>
  <title>DevOps Assignment - Java API on GKE</title>
</head>
<body>

<h1>Java Spring Boot REST API on GKE with TLS and Monitoring</h1>

<h2>1. Objective</h2>
<p>This project demonstrates the deployment of a containerized Java Spring Boot API to Google Kubernetes Engine (GKE), with secure HTTPS access via NGINX Ingress and Let's Encrypt TLS certificates, and monitoring using Prometheus and Grafana.</p>

<h2>2. Containerization</h2>
<ul>
  <li>Java Spring Boot REST API</li>
  <li>Dockerfile created for the application</li>
  <li>Image built and pushed to Google Artifact Registry</li>
  <li>Example image URL: <code>us-central1-docker.pkg.dev/betbazar-ops/java-api-repo-kavindu/springboot-restapi-kavindu</code></li>
</ul>

<h2>3. Kubernetes Setup</h2>
<ul>
  <li>Namespace used: <code>nginx-private</code></li>
  <li>Deployment and service applied using kubectl</li>
</ul>

<h2>4. Ingress Configuration</h2>
<ul>
  <li>Installed Bitnami NGINX Ingress Controller via Helm</li>
  <li>Custom IngressClass: <code>nginx-private</code></li>
  <li>Ingress configured to route traffic from <code>www.kavinducloudops.tech</code> to the Java API</li>
</ul>

<pre>
kubectl apply -f 08-ingress.yaml -n nginx-private
</pre>

<h2>5. TLS via cert-manager</h2>
<ul>
  <li>cert-manager installed using official YAML</li>
  <li>ClusterIssuer created for Let's Encrypt (staging)</li>
  <li>Certificate resource created to issue TLS cert</li>
  <li>TLS secret: <code>java-api-tls-secret</code></li>
</ul>

<h3>ClusterIssuer Example:</h3>
<pre>
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: kavigayashan149@gmail.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
      - http01:
          ingress:
            class: nginx-private
</pre>

<h3>Certificate Example:</h3>
<pre>
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-tls
  namespace: nginx-private
spec:
  secretName: java-api-tls-secret
  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer
  commonName: www.kavinducloudops.tech
  dnsNames:
    - www.kavinducloudops.tech
</pre>

<h2>6. DNS Configuration</h2>
<ul>
  <li>Domain used: <code>www.kavinducloudops.tech</code></li>
  <li>A record pointed to the LoadBalancer IP of the Ingress</li>
  <li>Final IP: <code>35.224.125.190</code></li>
</ul>

<h2>7. Monitoring with Prometheus and Grafana</h2>
<ul>
  <li>Installed kube-prometheus-stack via Helm</li>
  <li>Namespace: <code>monitoring</code></li>
  <li>Grafana accessed via port-forwarding on port 3000</li>
  <li>Default login: admin / decoded password from secret</li>
</ul>

<pre>
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
</pre>

<h2>8. Verification</h2>
<ul>
  <li>Check Ingress IP: <code>kubectl get ingress -n nginx-private</code></li>
  <li>Check TLS secret: <code>kubectl get secret java-api-tls-secret -n nginx-private</code></li>
  <li>Check cert status: <code>kubectl describe certificate my-tls -n nginx-private</code></li>
  <li>Open: <a href="https://www.kavinducloudops.tech">https://www.kavinducloudops.tech</a></li>
</ul>

<h2>9. Tools Used</h2>
<ul>
  <li>Google Kubernetes Engine (GKE)</li>
  <li>Docker</li>
  <li>Helm</li>
  <li>Bitnami charts</li>
  <li>cert-manager</li>
  <li>Prometheus</li>
  <li>Grafana</li>
</ul>

<h2>10. Conclusion</h2>
<p>The application is now securely exposed over HTTPS with a trusted TLS certificate, monitored with Prometheus and Grafana, and accessible via a custom domain using NGINX Ingress on GKE.</p>

</body>
</html>
