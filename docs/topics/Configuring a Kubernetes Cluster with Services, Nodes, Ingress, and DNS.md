
In this guide, we will deploy a **Kubernetes cluster** and configure:

✅ **Nodes** (Worker + Control Plane)  
✅ **Service** for accessing pods  
✅ **Ingress** for HTTP request routing  
✅ **DNS** inside the cluster  

## 1. Deploying a Kubernetes Cluster  

📌 You can deploy a cluster using different methods:  

• **Minikube** (for local testing).  
• **Kubeadm** (for production clusters).  
• **K3s** (a lightweight version for small projects).  

### **Deploying with Minikube (Locally)**  

```  
minikube start  
```  

Check the nodes:  

```  
kubectl get nodes  
```  

## 2. Deploying a Service in Kubernetes  

We will create a **Deployment** with pods and a **Service** to expose them.  

📌 **File: deployment.yaml**  

```  
apiVersion: apps/v1  
kind: Deployment  
metadata:  
  name: my-app  
spec:  
  replicas: 3  
  selector:  
    matchLabels:  
      app: my-app  
  template:  
    metadata:  
      labels:  
        app: my-app  
    spec:  
      containers:  
      - name: my-app  
        image: nginx  
        ports:  
        - containerPort: 80  
```  

Deploy it:  

```  
kubectl apply -f deployment.yaml  
```  

Check the pods:  

```  
kubectl get pods  
```  

## 3. Configuring a Service (NodePort)  

To expose our application, we will create a **Service**.  

📌 **File: service.yaml**  

```  
apiVersion: v1  
kind: Service  
metadata:  
  name: my-service  
spec:  
  selector:  
    app: my-app  
  ports:  
    - protocol: TCP  
      port: 80  
      targetPort: 80  
      nodePort: 30080  # Port on nodes  
  type: NodePort  
```  

Apply it:  

```  
kubectl apply -f service.yaml  
```  

Check the service:  

```  
kubectl get svc  
```  

Now the application is accessible via:  

```  
minikube service my-service --url  
```  

## 4. Configuring Ingress for Routing  

📌 **Enable Ingress Controller in Minikube**  

```  
minikube addons enable ingress  
```  

For other clusters, use **NGINX Ingress Controller**:  

```  
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml  
```  

📌 **File: ingress.yaml**  

```  
apiVersion: networking.k8s.io/v1  
kind: Ingress  
metadata:  
  name: my-ingress  
  annotations:  
    nginx.ingress.kubernetes.io/rewrite-target: /  
spec:  
  rules:  
  - host: myapp.local  
    http:  
      paths:  
      - path: /  
        pathType: Prefix  
        backend:  
          service:  
            name: my-service  
            port:  
              number: 80  
```  

Apply it:  

```  
kubectl apply -f ingress.yaml  
```  

Add the domain to /etc/hosts (for local testing):  

```  
echo "$(minikube ip) myapp.local" | sudo tee -a /etc/hosts  
```  

Now the application is accessible at **http://myapp.local**  

## 5. DNS in Kubernetes  

Kubernetes uses **CoreDNS** for internal DNS management.  

📌 Check if CoreDNS is running:  

```  
kubectl get pods -n kube-system | grep coredns  
```  

📌 Check service resolution:  

```  
kubectl run dns-test --image=busybox --restart=Never -- nslookup my-service.default.svc.cluster.local  
```  

Expected output:  

```  
Server:    10.96.0.10  
Address:   10.96.0.10#53  
Name:      my-service.default.svc.cluster.local  
Address:   10.104.116.230  
```  

If it’s not working, enable CoreDNS:  

```  
kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml  
```  

## 🚀 Final Architecture  

```  
+------------------------+  
|  User                 |  
|  (curl myapp.local)   |  
+----------+------------+  
           |  
+----------v------------+  
|       Ingress         |   (Routes HTTP requests)  
+----------+------------+  
           |  
+----------v------------+  
|       Service         |   (Proxy for pods)  
+----------+------------+  
           |  
+----------v------------+  
|       Pods (Nginx)    |   (Containers running the app)  
+------------------------+  
```  

## 📌 Summary  

✅ Deployed **Kubernetes**  
✅ Created a **Service** (NodePort)  
✅ Configured **Ingress** for routing  
✅ Verified **DNS** inside the cluster  

Now you have a fully functional **Kubernetes application** with network infrastructure! 🚀  

---

# 🚀 Assigning an External IP in Kubernetes  

If you have a **dedicated external IP**, you can use it with **Service**, **Ingress**, or a **LoadBalancer**.  

## 1. Using ExternalIPs in a Service  

If you have a static external IP, you can specify it in externalIPs for direct traffic forwarding.  

📌 **Example: service.yaml with external IP**  

```  
apiVersion: v1  
kind: Service  
metadata:  
  name: my-service  
spec:  
  type: ClusterIP  # External IP is manually set  
  selector:  
    app: my-app  
  externalIPs:  
    - 203.0.113.10  # Your external IP  
  ports:  
    - protocol: TCP  
      port: 80  
      targetPort: 80  
```  

📌 **Check the service:**  

```  
kubectl apply -f service.yaml  
kubectl get svc my-service  
```  

Now the service will be accessible at **http://203.0.113.10:80**.  

⚠️ **Limitations:**  

• Kubernetes **does not reserve** this IP; it must be pre-configured in your network.  
• Works only **if the external IP is manually assigned to a node** (e.g., via iptables).  

## 2. Using a LoadBalancer for Automatic External IP Allocation  

If you’re running in a **cloud provider environment** (AWS, GCP, Azure, DigitalOcean), use a LoadBalancer.  

📌 **Example: loadbalancer.yaml**  

```  
apiVersion: v1  
kind: Service  
metadata:  
  name: my-service  
spec:  
  type: LoadBalancer  
  selector:  
    app: my-app  
  ports:  
    - protocol: TCP  
      port: 80  
      targetPort: 80  
```  

📌 **Apply and check the assigned IP**:  

```  
kubectl apply -f loadbalancer.yaml  
kubectl get svc my-service  
```  

After deployment, an **external IP will be automatically assigned**.  

⚠️ **Limitations:**  

• Works **only in cloud environments** that support LoadBalancer.  
• It may take **a few minutes** to allocate an IP.  

## 3. Exposing a NodePort on a Static External IP  

If you have **a dedicated IP on one of the nodes**, you can use NodePort and manually configure port forwarding.  

📌 **Example: nodeport.yaml**  

```  
apiVersion: v1  
kind: Service  
metadata:  
  name: my-service  
spec:  
  type: NodePort  
  selector:  
    app: my-app  
  ports:  
    - protocol: TCP  
      port: 80  
      targetPort: 80  
      nodePort: 30080  # External node port  
```  

📌 **Configure port forwarding on a Linux server with an external IP**:  

```  
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 30080  
```  

Now the service is accessible at **http://203.0.113.10:80**.  

⚠️ **Limitations:**  

• **Not suitable for cloud environments** without manual setup.  
• Requires **iptables access** on the node.  

## Choosing the Best Method  

| **Method** | **Use When** | **Limitations** |  
|---|---|---|  
| externalIPs | Static external IP | Requires network setup |  
| LoadBalancer | Cloud environment | Cloud-only |  
| NodePort | Dedicated node IP | Requires iptables |  
| Ingress | Ingress Controller available | Needs Nginx/Traefik |  

Now your **Kubernetes service is accessible via an external IP!**  