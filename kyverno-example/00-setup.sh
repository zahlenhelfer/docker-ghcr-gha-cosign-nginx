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
--image ghcr.io/zahlenhelfer/docker-ghcr-gha-cosign-nginx:latest

kubectl run test \
-n signed \
--image ghcr.io/zahlenhelfer/docker-ghcr-gha-cosign-nginx@sha256:e8f756722068ebdfbfa45d875a1d7a90110d687825bf8feba5e5c183d2f7b320


cosign verify \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  ghcr.io/zahlenhelfer/docker-ghcr-gha-cosign-nginx@sha256:e8f756722068ebdfbfa45d875a1d7a90110d687825bf8feba5e5c183d2f7b320


kubectl run test \
-n signed \
--image nginx:latest

kubectl run test \
-n default \
--image nginx:latest