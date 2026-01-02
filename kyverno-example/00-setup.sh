#!/bin/bash
kind create cluster \
  --name kyverno-lab \
  --config kind-config.yaml

kubectl cluster-info

kubectl create -f https://github.com/kyverno/kyverno/releases/latest/download/install.yaml

kubectl -n kyverno rollout status deployment

kubectl create namespace signed

kubectl apply -f verify-zh-ghcr-images.yaml

kubectl get clusterpolicy


kubectl run test \
-n signed \
--image nginx:latest

kubectl run test \
-n default \
--image nginx:latest