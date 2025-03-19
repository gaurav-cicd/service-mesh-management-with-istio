#!/bin/bash

# Exit on error
set -e

echo "Starting Istio Service Mesh Deployment..."

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if istioctl is installed
if ! command -v istioctl &> /dev/null; then
    echo "istioctl is not installed. Please install istioctl first."
    exit 1
fi

# Create namespace if it doesn't exist
kubectl create namespace istio-system --dry-run=client -o yaml | kubectl apply -f -

# Install Istio using the custom configuration
echo "Installing Istio..."
istioctl install -f kubernetes/istio/istio-config.yaml --skip-confirmation

# Wait for Istio components to be ready
echo "Waiting for Istio components to be ready..."
kubectl wait --for=condition=ready pod -l app=istiod -n istio-system --timeout=300s

# Enable automatic sidecar injection for the default namespace
echo "Enabling automatic sidecar injection..."
kubectl label namespace default istio-injection=enabled --overwrite

# Deploy sample services
echo "Deploying sample services..."
kubectl apply -f kubernetes/services/

# Deploy monitoring stack
echo "Deploying monitoring stack..."
kubectl apply -f kubernetes/monitoring/

# Wait for services to be ready
echo "Waiting for services to be ready..."
kubectl wait --for=condition=ready pod -l app=book-service -n default --timeout=300s

# Port-forward Kiali dashboard
echo "Setting up Kiali dashboard..."
kubectl port-forward -n istio-system svc/kiali 20001:20001 &
KIALI_PID=$!

# Port-forward Grafana dashboard
echo "Setting up Grafana dashboard..."
kubectl port-forward -n istio-system svc/grafana 3000:3000 &
GRAFANA_PID=$!

echo "Deployment completed successfully!"
echo "Access the dashboards at:"
echo "Kiali: http://localhost:20001"
echo "Grafana: http://localhost:3000"
echo "Default credentials for Grafana: admin/admin"

# Keep the script running
trap "kill $KIALI_PID $GRAFANA_PID" EXIT
wait 