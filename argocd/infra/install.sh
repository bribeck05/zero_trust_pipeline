#!/bin/bash

INFRA_LIST=(
  "applicationset-controller"
  "dex-server"
  "metrics"
  "notifications-controller-metrics"
  "redis"
  "repo-server"
  "server"
)

CONFIG_LIST=(
  "secrets"
  "role"
  "rbac"
  "configmap"
  "crd"
  "networkpolicy"
)

if [ "$(dirname $0)" != "." ]; then
  echo "you should execute this script on tools directory"
  exit 1
fi

gcloud container clusters get-credentials kc-d-devops-main --region asia-northeast1-a --project prj-d-devops-402107
kubectl create namespace argocd
kubectl config set-context --current --namespace argocd

CURR_DIR=$(pwd)

echo "Set up Config"
for CONFIG in "${CONFIG_LIST[@]}"; do
  kubectl apply -f ${CONFIG}.yaml
done

echo "Set up Infra"
for INFRA in "${INFRA_LIST[@]}"; do
  cd $CURR_DIR/$INFRA
  kubectl apply -k .
  cd $CURR_DIR
done