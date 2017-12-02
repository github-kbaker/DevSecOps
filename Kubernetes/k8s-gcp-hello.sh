# This bash script uses Kubernetes to establish within Google cloud a multi-service sample application named hello.
# This automates manual steps within the Orchestrating the Cloud with Kubernetes lab at https://google.qwiklabs.com/focuses/7012

# In a Goolge Cloud Console run this script using this command:
# bash <(curl -s https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/Kubernetes/k8s-gcp-hello.sh)

# PROTIP: Define environment variable for use in several commands below:
# bash <(curl -O https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp-set-my-zone.sh)
export MY_ZONE="us-central1-b"
gcloud config set compute/zone ${MY_ZONE}
   if [ $? -eq 0 ]; then echo OK else echo FAIL fi

# PROTIP: Use repo forked from googlecodelabs to ensure that this remains working:
git clone https://github.com/wilsonmar/orchestrate-with-kubernetes.git
cd orchestrate-with-kubernetes/kubernetes
ls
   # cleanup.sh deployments  nginx  pods  services  tls
   
# List what GKE clusters are left over from previous run:
gcloud compute instances list
   # NAME                                     ZONE           MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP      STATUS
   # gke-io-default-pool-c8cd677e-gfzq        us-central1-b  n1-standard-1               10.128.0.8   35.192.220.202   RUNNING
   # gke-io-default-pool-c8cd677e-nqrb        us-central1-b  n1-standard-1               10.128.0.7   35.202.233.114   RUNNING
   # gke-io-default-pool-c8cd677e-xhv8        us-central1-b  n1-standard-1               10.128.0.9   35.193.71.132    RUNNING
   if [ $? -eq 0 ]; then echo OK else echo FAIL fi

# Delete what was created in previous session:
chmod +x cleanup.sh  # to avoid -bash: ./cleanup.sh: Permission denied
./cleanup.sh
   # This error is expected when run the first time:
   # The connection to the server localhost:8080 was refused - did you specify the right host or port?
   if [ $? -eq 0 ]; then echo OK else echo FAIL fi

# If they exist, delete them:
gcloud container clusters delete io --zone ${MY_ZONE}
   # The following clusters will be deleted.
   # - [io] in [us-central1-b]
   # Do you want to continue (Y/n)?  Y
   # Deleting cluster io...done.
   # Deleted [https://container.googleapis.com/v1/projects/cicd-182518/zones/us-central1-b/clusters/io].
   if [ $? -eq 0 ]; then echo OK else echo FAIL fi
