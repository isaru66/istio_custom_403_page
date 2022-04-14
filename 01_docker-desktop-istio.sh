# This code expected to be run at istio downloaded folder with Docker Desktop that enable Kubernate Engine

# Switch Context to Docker Desktop
kubectl config use-context docker-desktop
# SHOW CURRENT K8S CLUSTER
kubectl cluster-info
# PROMPT FOR CONFIRMATION
read -p "Is cluster correct? Y to continue, Ctrl-C to exit " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancel"
    exit 1
fi 

# INSTALL INSTIO AND ENABLE SIDECAR INJECTION ON DEFAULT NAMESPACE
./bin/istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled

# Set the ingress IP and ports
export INGRESS_HOST=127.0.0.1
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT