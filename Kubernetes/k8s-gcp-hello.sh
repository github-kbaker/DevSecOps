# This bash script uses Kubernetes to establish within Google cloud a multi-service sample application named hello.
# This automates manual steps within the Orchestrating the Cloud with Kubernetes lab at https://google.qwiklabs.com/focuses/7012

# In a Goolge Cloud Console run this script using this command:
# bash <(curl -s https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/Kubernetes/k8s-gcp-hello.sh)

# PROTIP: Define environment variable for use in several commands below:
# bash <(curl -O https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp-set-my-zone.sh)
export MY_ZONE="us-central1-b"
gcloud config set compute/zone ${MY_ZONE}
