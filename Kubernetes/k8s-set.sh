# This bash script uses Kubernetes to establish within Google cloud a multi-service application.

git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
cd orchestrate-with-kubernetes/kubernetes
ls

# Define Zone within Google Cloud:
# bash <(curl -s https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp-set-zone.sh)
gcloud config set compute/zone us-central1-b

# cleanup.sh deployments  nginx  pods  services  tls
# Clean up (delete) what was created in previous session:
chmod +x cleanup.sh
./cleanup.sh

# List what GKE clusters are left over from previous run:
gcloud compute instances list
   # NAME                                     ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP      STATUS
   # gke-io-default-pool-c8cd677e-gfzq        us-central1-b  n1-standard-1               10.128.0.8   35.192.220.202   RUNNING
   # gke-io-default-pool-c8cd677e-nqrb        us-central1-b  n1-standard-1               10.128.0.7   35.202.233.114   RUNNING
   # gke-io-default-pool-c8cd677e-xhv8        us-central1-b  n1-standard-1               10.128.0.9   35.193.71.132    RUNNING

# If they exist, delete them:
gcloud container clusters delete io --zone us-central1-b
   # The following clusters will be deleted.
   # - [io] in [us-central1-f]
   # Do you want to continue (Y/n)?  Y
   # Deleting cluster io...done.
   # Deleted [https://container.googleapis.com/v1/projects/cicd-182518/zones/us-central1-b/clusters/io].

# Start up a cluster:
gcloud container clusters create io
   # Response takes several minutes: Creating cluster io ...|
   # reating cluster io...done.
   # Created [https://container.googleapis.com/v1/projects/cicd-182518/zones/us-central1-b/clusters/io].
   # kubeconfig entry generated for io.
   # NAME  ZONE           MASTER_VERSION  MASTER_IP     MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
   # io    us-central1-b  1.7.8-gke.0     35.193.92.75  n1-standard-1  1.7.8-gke.0   3          RUNNING
   
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
   # pod "monolith" created

# list pods running in the default namespace:
kubectl get pods
   # NAME                     READY     STATUS    RESTARTS   AGE
   # monolith                 1/1       Running   0          26s
   # nginx-1803751077-wcb7d   1/1       Running   0          1h

# Get information about pods named monolith:
kubectl describe pods monolith
   # This lists IP address (such as 10.4.0.4), Status, Containers, Conditions, Events.

# Map a local port to a port inside the monolith pod:

# Manually open a 2nd terminal (clicking the "+" to "Add Cloud Shell session") to set up port-forwarding:
kubectl port-forward monolith 10080:80
   # Forwarding from 127.0.0.1:10080 -> 80

# Manually open a 3rd terminal (Cloud Shell session) to talking to our pod:
# curl http://127.0.0.1:10080
   # {"message":"Hello"}

# Also on the 3rd terminal, hit a secure endpoint:
# curl http://127.0.0.1:10080/secure
   # authorization failed

# Because Cloud shell doesn't handle copying long strings well:
# In the 3rd terminal, Capture in an environment variable the token returned in response to manually log in:
TOKEN=$(curl http://127.0.0.1:10080/login -u user|jq -r '.token')
   # Enter host password for user 'user':
# Manually type in the (super-secret) password "password" to login.
   # Logging in caused a JWT token to print out
   # {"token":"eyJhbGci..."}

# Copy the token and use it to hit our secure endpoint with curl into an environment variable for use in the previous step.
curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:10080/secure
   # {"message":"Hello"}

# View app logs entries for the monolith Pod:
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
   
gcloud compute instances list
   
# Try hitting the secure-monolith service:
# curl -k https://<EXTERNAL_IP>:31000

# By default the monolith service is not setup with endpoints. 
# Troubleshoot an issue like this is to use the kubectl get pods command with a label query.

# List pods running with the monolith label:
kubectl get pods -l "app=monolith"

# But what about "app=monolith" and "secure=enabled"?
kubectl get pods -l "app=monolith,secure=enabled"

Notice this label query does not print any results. It seems like we need to add the "secure=enabled" label to them.

# Add "secure=enabled" label to the secure-monolith Pod. 
kubectl label pods secure-monolith 'secure=enabled'

# Check and see whether labels have been updated:
kubectl get pods secure-monolith --show-labels

# View the list of endpoints on the monolith service:
kubectl describe services monolith | grep Endpoints

# Hit one of our nodes again:
gcloud compute instances list

# View:
# curl -k https://<EXTERNAL_IP>:31000

#### Deployment

# break the monolith app into three separate pieces:
   # auth - Generates JWT tokens for authenticated users.
   # hello - Greet authenticated users.
   # frontend - Routes traffic to the auth and hello services.
   # See http://kubernetes.io/docs/user-guide/deployments/#what-is-a-deployment

# Notice deployments/auth.yaml specifies creation of 1 replica called "auth" from Kelsey:
kubectl create -f deployments/auth.yaml

# Create a service for your auth deployment:
kubectl create -f services/auth.yaml

# Create and expose the hello app Deployment:
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

# Create and expose the frontend Deployment:
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

# Interact with the frontend by grabbing it's External IP and then curling to it:
kubectl get services frontend
# curl -k https://<EXTERNAL-IP>

# Delete using a script:
chmod +x cleanup.sh
./cleanup.sh

gcloud container clusters delete io --zone 
