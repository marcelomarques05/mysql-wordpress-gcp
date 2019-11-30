#!/bin/bash

clear

# Variables
PROJECT=`gcloud config get-value project`
CLUSTER_NAME="k8s-course"
ZONE=`gcloud config get-value compute/zone`
REGION=`gcloud config get-value compute/region`

# Install Beta Modules for GCloud
gcloud components install beta --quiet

# Create K8S Cluster
gcloud beta container --project "${PROJECT}" \
    clusters create "${CLUSTER_NAME}" \
    --zone "${ZONE}" \
    --no-enable-basic-auth \
    --cluster-version "1.13.11-gke.14" \
    --machine-type "n1-standard-1" \
    --metadata disable-legacy-endpoints=true \
    --image-type "COS" \
    --disk-type "pd-standard" \
    --disk-size "100" \
    --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
    --num-nodes "3" \
    --enable-stackdriver-kubernetes \
    --enable-ip-alias --network "projects/${PROJECT}/global/networks/default" \
    --subnetwork "projects/${PROJECT}/regions/${REGION}/subnetworks/default" \
    --default-max-pods-per-node "50" \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing \
    --enable-autorepair

# Generate MySQL Password into K8S Secrets
kubectl create secret generic mysql-pass --from-literal=password='passw0rd'

# Create the K8S Objects
kubectl create -f mysql-deployment.yaml
kubectl create -f wordpress-deployment.yaml

# Check the Objects
kubectl get pods
kubectl get deployments
kubectl get pvc
kubectl get services

echo
echo "That's it. Try to run again the command 'kubectl get services' to get the IP address to check the WordPress webpage. Feel free to contact me. :)"
