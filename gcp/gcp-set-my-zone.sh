#!/bin/bash

# This sets the default zone on Google Compute Cloud 
# such that all scripts use a consistent zone and region in Google Cloud.

# Run this with command:
# bash <(curl -O https://raw.githubusercontent.com/wilsonmar/Dockerfiles/master/gcp/gcp-set-my-zone.sh)
# Described in https://wilsonmar.github.io/gcp

   export CLOUDSDK_COMPUTE_ZONE=us-central1-d
   export CLOUDSDK_COMPUTE_REGION=us-central1 
   echo $GCP_ZONE
   echo $GCP_REGION
   # NOTE: There are also variables CLOUDSDK_COMPUTE_ZONE and CLOUDSDK_COMPUTE_REGION noted in Google documentation.

gcloud config set compute/zone ${GCP_ZONE}
   if [ $? -eq 0 ]; then echo OK else echo FAIL fi


