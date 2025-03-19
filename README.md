# Service Mesh Management with Istio

This project demonstrates automated service mesh deployment and monitoring using Istio, Kubernetes, and Splunk.

## Project Overview

This project implements a service mesh architecture using Istio to manage microservices communication, implement traffic management, and provide observability.

### Key Features

- Istio service mesh deployment with Envoy sidecars
- Traffic management (canary deployments, circuit breaking)
- Service visualization using Kiali
- Metrics collection and monitoring
- Automated reporting

## Prerequisites

- Kubernetes cluster (v1.20+)
- kubectl CLI
- Istio CLI
- Splunk Enterprise (for log aggregation)
- Helm (for package management)

## Project Structure

```
.
├── README.md
├── kubernetes/
│   ├── istio/           # Istio installation manifests
│   ├── services/        # Sample microservices
│   └── monitoring/      # Monitoring configurations
├── scripts/             # Automation scripts
└── docs/               # Additional documentation
```

## Getting Started

1. Install Istio:
   ```bash
   istioctl install --set profile=demo
   ```

2. Deploy sample services:
   ```bash
   kubectl apply -f kubernetes/services/
   ```

3. Configure monitoring:
   ```bash
   kubectl apply -f kubernetes/monitoring/
   ```

4. Access Kiali dashboard:
   ```bash
   istioctl dashboard kiali
   ```

## Traffic Management

The project includes configurations for:
- Canary deployments
- Circuit breaking
- Load balancing
- Traffic shifting

## Monitoring and Observability

- Service metrics visualization through Kiali
- Distributed tracing with Jaeger
- Log aggregation with Splunk
- Automated reporting system

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
