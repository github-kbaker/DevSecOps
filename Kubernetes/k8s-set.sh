# Delete what was created in previous session:
# TBD

# Define Zone within Google Cloud = gcloud config set compute/zone us-central1-b
bash <(curl -s https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp-set-zone.sh)

# Start up a cluster:
gcloud container clusters create io
   # Response takes several minutes: Creating cluster io ...|
   # reating cluster io...done.
   # Created [https://container.googleapis.com/v1/projects/cicd-182518/zones/us-central1-b/clusters/io].
   # kubeconfig entry generated for io.
   # NAME  ZONE           MASTER_VERSION  MASTER_IP     MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
   # io    us-central1-b  1.7.8-gke.0     35.193.92.75  n1-standard-1  1.7.8-gke.0   3          RUNNING
   
git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
cd orchestrate-with-kubernetes/kubernetes
ls
   # cleanup.sh deployments  nginx  pods  services  tls

# Launch a single instance of the nginx container:
kubectl run nginx --image=nginx:1.10.0
   # deployment "nginx" created

# View containers running in pods:
kubectl get pods
   # NAME                     READY     STATUS    RESTARTS   AGE
   # nginx-1803751077-wcb7d   1/1       Running   0          1m
   # See https://kubernetes.io/docs/concepts/workloads/pods/pod/

# Expose outside Kubernetes the nginx container through a LoadBalancer:
kubectl expose deployment nginx --port 80 --type LoadBalancer
   # service "nginx" exposed

# Run every minute until the EXTERNAL-IP goes from <pending>:
kubectl get services
   # NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
   # kubernetes   ClusterIP      10.7.240.1     <none>        443/TCP        20m
   # nginx        LoadBalancer   10.7.250.125   <pending>     80:30839/TCP   1m

# View the HTML that comes back from calling the EXTERNAL-IP:
# curl http://<External IP>:80

# Create a single 10MB pod kelseyhightower's monolith image, listening on port 80, with a health UI on port 81:
kubectl create -f pods/monolith.yaml

# list pods running in the default namespace:
kubectl get pods

# Information about the monolith pod created:
kubectl describe pods monolith

# Map a local port to a port inside the monolith pod:

# Manually open a 2nd terminal, run this command to set up port-forwarding:
kubectl port-forward monolith 10080:80

# Manually open a 3rd terminal to talking to our pod:
# curl http://127.0.0.1:10080
   # hello should appear

# hit a secure endpoint:
# curl http://127.0.0.1:10080/secure

# Manually log in to get an auth token back from our Monolith:
# curl -u user http://127.0.0.1:10080/login
   # use the super-secret password "password" to login.
   # Logging in caused a JWT token to print out
   # TOKEN=$(curl http://127.0.0.1:10080/login -u user|jq -r '.token')

# Copy the token and use it to hit our secure endpoint with curl into an environment variable for use in the previous step.
# This is because Cloud shell doesn't handle copying long strings well.
# curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:10080/secure

# Ciew app logs for the monolith Pod:
kubectl logs monolith

# Open a 3rd terminal and use the -f flag to get a stream of the logs happening in real-time:
# kubectl logs -f monolith

# Now if you use curl to interact with the monolith, you can see the logs updating (in terminal 3):
# curl http://127.0.0.1:10080

# Open an interactive shell inside the Monolith Pod to troubleshoot from within a container:
# kubectl exec monolith --stdin --tty -c monolith /bin/sh

# Shell into the monolith container we can test external connectivity using the ping command:
# ping -c 3 google.com
# exit

# See http://kubernetes.io/docs/user-guide/services/

# Create secure-monolith pods and their configuration data:
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
kubectl create -f pods/secure-monolith.yaml

# Expose the secure-monolith Pod externally by creating a Kubernetes service using services/monolith.yaml:
# selector is used to automatically find and expose any pods with the labels "app=monolith" and "secure=enabled"
kubectl create -f services/monolith.yaml
   # service "monolith" created
   # See http://releases.k8s.io/release-1.2/docs/user-guide/services-firewalls.md
   
# Allow traffic to the monolith service on the exposed nodeport:
gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000
   


