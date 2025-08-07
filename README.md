# DevOps Assignment - Java API with Kubernetes

A complete DevOps implementation featuring a Java Spring Boot API deployed on Google Kubernetes Engine (GKE) with monitoring, auto-scaling, TLS encryption, and production-ready infrastructure.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Internet      │────│  NGINX Ingress   │────│  Java API Pods │
│                 │    │  (TLS/HTTPS)     │    │  (Auto-scaling) │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │  LoadBalancer    │
                       │  Service         │
                       └──────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │  Monitoring      │
                       │  Prometheus +    │
                       │  Grafana         │
                       └──────────────────┘
```

## 🚀 Features

- ✅ **Java Spring Boot REST API** with CRUD operations
- ✅ **Docker containerization** with multi-stage builds
- ✅ **Kubernetes orchestration** on Google Cloud Platform
- ✅ **Auto-scaling** with Horizontal Pod Autoscaler (HPA)
- ✅ **Load balancing** with external LoadBalancer service
- ✅ **HTTPS/TLS encryption** with Let's Encrypt certificates
- ✅ **Domain routing** with NGINX Ingress Controller
- ✅ **Comprehensive monitoring** with Prometheus and Grafana
- ✅ **Production-ready** infrastructure with proper resource limits

## 📋 Prerequisites

- Google Cloud Platform account with billing enabled
- Docker installed locally
- `gcloud` CLI tool installed and configured
- `kubectl` command-line tool
- `helm` package manager for Kubernetes
- Domain name (optional, for HTTPS access)

## 🛠️ Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/Gaya2001/DevOps-Assignment-Behaviol.git
cd DevOps-Assignment-Behaviol
```

### 2. Create GKE Cluster
```bash
# Create GKE cluster
gcloud container clusters create java-api-cluster-kavindu \
    --zone=us-central1-a \
    --num-nodes=3 \
    --machine-type=e2-medium \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=5

# Get cluster credentials
gcloud container clusters get-credentials java-api-cluster-kavindu --zone=us-central1-a
```

### 3. Build and Deploy Application
```bash
# Build the JAR file
./mvnw clean package -DskipTests

# Build and push Docker image to Google Artifact Registry
gcloud builds submit --tag gcr.io/[YOUR-PROJECT-ID]/java-api:v1

# Run the automated setup script
bash setup-script.sh
```

### 4. Monitor Your Deployment
```bash
# Check status of all components
bash monitoring-script.sh
```

## 📸 Screenshots & Demo

### 🎯 API Response Demo
![API Response](screenshots/Output.png)
*Example API response showing user data retrieval*

### 📊 Grafana Dashboard
![Grafana Dashboard](screenshots/Grafana.png)
*Real-time monitoring dashboard showing application metrics*

### ☸️ Kubernetes Dashboard
![Kubernetes Pods](screenshots/Pod_Status_java-api-kavindu.png)
*Kubernetes pods running in production environment*

### 🔒 TLS Certificate Status
![TLS Certificate](screenshots/TLS certificate.png)
*Let's Encrypt certificate validation and HTTPS status*

## 🌐 Access Points

After deployment, your application will be accessible via:

### Direct Service Access
- **API Endpoint**: `http://35.226.27.171:8080/api/users`
- **Health Check**: `http://35.226.27.171:8080/actuator/health`

### Domain Access (if DNS configured)
- **HTTPS**: `https://www.kavinducloudops.tech/api/users`
- **HTTP**: `http://www.kavinducloudops.tech/api/users` (redirects to HTTPS)

### Monitoring Dashboards
- **Prometheus**: `http://34.30.81.46:9090`
- **Grafana**: `http://34.71.216.190:3000` (admin/admin123)

## 📁 Project Structure

```
DevOps-Assignment-Behaviol/
├── src/
│   ├── main/
│   │   ├── java/com/example/spring/
│   │   │   ├── Application.java              # Main Spring Boot application
│   │   │   ├── controller/UserController.java # REST API endpoints
│   │   │   ├── model/User.java               # User data model
│   │   │   └── service/UserService.java     # Business logic
│   │   └── resources/
│   │       └── application.properties        # App configuration
│   └── test/
├── k8s/                                      # Kubernetes manifests
│   ├── 01-namespace.yaml                     # Namespace definition
│   ├── 02-configmap.yaml                     # Configuration data
│   ├── 03-deployment.yml                     # Application deployment
│   ├── 04-secret.yaml                        # Secret data
│   ├── 05-service.yaml                       # LoadBalancer service
│   ├── 06-hpa.yaml                           # Horizontal Pod Autoscaler
│   ├── 07-ingress.yaml                       # NGINX Ingress with TLS
│   ├── 08-certificate.yaml                   # TLS certificate config
│   └── cluster-issuer.yaml                   # cert-manager issuer
├── dashboards/                               # Grafana dashboard configs
│   ├── kubernetes-cluster-dashboard.json
│   ├── java-api-dashboard.json
│   └── node-exporter-dashboard.json
├── Dockerfile                                # Container definition
├── pom.xml                                   # Maven configuration
├── setup-script.sh                           # Automated deployment script
├── monitoring-script.sh                      # Health check script
├── cleanup-script.sh                         # Resource cleanup script
└── README.md                                 # This file
```

## 🔧 Configuration Details

### Application Configuration
- **Framework**: Spring Boot 3.5.3
- **Java Version**: 17
- **Dependencies**: Web, Actuator, Prometheus metrics, Lombok
- **Build Tool**: Maven
- **Container**: OpenJDK 17 Alpine

### Kubernetes Resources
- **Namespace**: `java-api-kavindu`
- **Replicas**: 2 (auto-scaling 1-3 based on CPU/memory)
- **Resource Limits**: 500m CPU, 512Mi memory
- **Resource Requests**: 250m CPU, 256Mi memory
- **Health Checks**: Readiness and liveness probes on `/api/users`

### Auto-scaling Configuration
- **Min Replicas**: 1
- **Max Replicas**: 3
- **CPU Threshold**: 70%
- **Memory Threshold**: 80%

### TLS/HTTPS Configuration
- **Certificate Authority**: Let's Encrypt (staging)
- **Domain**: `www.kavinducloudops.tech`
- **Automatic Renewal**: Enabled via cert-manager

## � Monitoring Setup

### Prometheus Metrics
- Application metrics via `/actuator/prometheus`
- Kubernetes cluster metrics via kube-state-metrics
- Node metrics via node-exporter
- Container metrics via cAdvisor

### Grafana Dashboards
- **Kubernetes Cluster Overview**: Pod status, resource usage, cluster health
- **Java API Monitoring**: Application-specific metrics, request rates, response times
- **Node Infrastructure**: CPU, memory, disk, network metrics

## 🛡️ Security Features

- **TLS Encryption**: HTTPS with Let's Encrypt certificates
- **Resource Limits**: Prevent resource exhaustion
- **Network Policies**: Controlled inter-pod communication
- **Secret Management**: Encrypted storage of sensitive data
- **Health Checks**: Automatic pod restart on failures

## 📈 Performance & Scaling

- **Horizontal Pod Autoscaler**: Automatic scaling based on CPU/memory usage
- **Load Balancing**: Traffic distribution across multiple pods
- **Resource Optimization**: Efficient resource allocation and limits
- **Health Monitoring**: Continuous health checks and automatic recovery

## � Monitoring & Observability

### Health Check Script
```bash
# Run comprehensive health check
bash monitoring-script.sh
```

### Manual Monitoring Commands
```bash
# Check pod status
kubectl get pods -n java-api-kavindu

# View application logs
kubectl logs -f deployment/java-api-deployment -n java-api-kavindu

# Check auto-scaling status
kubectl get hpa -n java-api-kavindu

# Monitor resource usage
kubectl top pods -n java-api-kavindu
```

## 🧹 Cleanup

### Remove All Resources
```bash
# Run cleanup script (removes everything except GKE cluster)
bash cleanup-script.sh

# Or manually delete the entire cluster
gcloud container clusters delete java-api-cluster-kavindu --zone=us-central1-a
```

## 🌍 DNS Configuration

To use your custom domain:

1. **Configure DNS A Records** with your domain registrar:
   ```
   Type: A Record
   Name: www
   Value: 34.42.56.198  (Ingress IP)
   TTL: 300
   
   Type: A Record
   Name: @
   Value: 34.42.56.198  (Ingress IP)
   TTL: 300
   ```

2. **Get Ingress IP**:
   ```bash
   kubectl get ingress java-api-ingress -n java-api-kavindu
   ```

3. **Wait for DNS propagation** (5 minutes to 48 hours)

## � Troubleshooting

### Common Issues

1. **Pods not starting**:
   ```bash
   kubectl describe pods -n java-api-kavindu
   kubectl logs [POD-NAME] -n java-api-kavindu
   ```

2. **External IP pending**:
   ```bash
   kubectl get services -n java-api-kavindu
   # Wait a few minutes for GCP to assign external IP
   ```

3. **TLS certificate issues**:
   ```bash
   kubectl get certificates -n java-api-kavindu
   kubectl describe certificate java-api-tls-secret -n java-api-kavindu
   ```

4. **DNS not resolving**:
   ```bash
   nslookup www.kavinducloudops.tech 8.8.8.8
   # Check DNS configuration with domain registrar
   ```

## 📝 API Endpoints

### User Management API
- **GET** `/api/users` - Get all users


### Health & Monitoring
- **GET** `/actuator/health` - Application health status
- **GET** `/actuator/prometheus` - Prometheus metrics
- **GET** `/actuator/info` - Application information

## � Cost Optimization

### Resource Management
- **Right-sizing**: Optimized resource requests and limits
- **Auto-scaling**: Scale down during low usage
- **Spot Instances**: Use preemptible VMs for cost savings
- **Cleanup**: Regular cleanup of unused resources

### Estimated Costs (GCP)
- **GKE Cluster**: ~$72/month (3 e2-medium nodes)
- **Load Balancers**: ~$18/month per external IP
- **Persistent Disks**: ~$4/month per 100GB
- **Network Egress**: Variable based on traffic

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Spring Boot** for the excellent Java framework
- **Kubernetes** for container orchestration
- **Google Cloud Platform** for reliable infrastructure
- **Prometheus & Grafana** for monitoring capabilities
- **cert-manager** for automated TLS certificate management
- **NGINX Ingress Controller** for load balancing and routing

## 📞 Support

For questions or issues:
- Create an issue in this repository
- Check the troubleshooting section above
- Review the monitoring script output for component status

---

**Built with ❤️ for DevOps learning and demonstration**

# View certificate status
kubectl describe certificate -n java-api-kavindu
```

## 🏆 Production Features

✅ **High Availability**: Multi-replica deployment  
✅ **Auto-scaling**: HPA based on CPU/Memory metrics  
✅ **Load Balancing**: External LoadBalancer service  
✅ **TLS Encryption**: Automated certificate management  
✅ **Health Monitoring**: Liveness and readiness probes  
✅ **Configuration Management**: ConfigMaps and Secrets  
✅ **Zero-downtime Deployments**: Rolling updates  
✅ **Resource Management**: CPU and memory limits  

## 📝 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users` | Get all users |


## 🚀 Current Status

### 📈 Live System Metrics
![System Status](screenshots/system-status.png)

**Deployment**: ✅ **SUCCESSFUL**  
**API Status**: ✅ **RUNNING** (HTTP 200)  
**External Access**: ✅ **AVAILABLE** at `http://35.226.27.171:8080`  
**Auto-scaling**: ✅ **ACTIVE** (2/2 pods ready)  
**TLS Certificate**: 🔄 **PROVISIONING** (Let's Encrypt validation in progress)  

### 🎬 Demo Videos & Screenshots

<details>
<summary>📊 Click to view Monitoring Dashboard Screenshots</summary>

#### Prometheus Metrics
![Prometheus Dashboard](screenshots/prometheus-dashboard.png)

#### Grafana Visualization
![Grafana Metrics](screenshots/grafana-metrics.png)

#### Kubernetes Resource Status
![K8s Resources](screenshots/k8s-resources.png)

</details>

<details>
<summary>🌐 Click to view API Testing Screenshots</summary>

#### GET /api/users Response
![API GET Response](screenshots/api-get-users.png)

#### Health Check Response
![Health Check](screenshots/health-check.png)

#### HTTPS Domain Access
![HTTPS Access](screenshots/https-domain.png)

</details>  

---

*This project demonstrates a complete DevOps pipeline with containerization, Kubernetes orchestration, TLS security, and production-ready monitoring on Google Cloud Platform.*
