#!/bin/bash

PROJECT=`gcloud config get-value project`
CLUSTER_NAME="k8s-course"
ZONE=`gcloud config get-value compute/zone`
gcloud beta container clusters delete ${CLUSTER_NAME} --zone ${ZONE} --quiet
