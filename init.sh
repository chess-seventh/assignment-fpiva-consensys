#!/bin/bash

set -e

function start_mini_kube {
	echo "Starting Minikube with Addons"
	minikube start --addons=ingress,istio,istio-provisioner,metrics-server,ingress-dns,registry --insecure-registry "192.168.0.0/16" --cpus=4
}

function install_argo {
	echo "Installing ArgoCD"
	kubectl create ns argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

	echo "Installing Argo Rollouts"
	kubectl create namespace argo-rollouts
	kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
}

function delete_minikube {
	while true; do
		read -p "$* Delete Minikube? [y/n]: " yn
		case $yn in
		[Yy]*) minikube delete ;;
		[Nn]*) echo "Not deleting Minikube instance" return 0 ;;
		esac
	done
}

function apply_argo_applications {
	echo "Applying Argo Applications"
	kubectl apply -f ./init-files/application-backstage.yaml
	kubectl apply -f ./init-files/application-prometheus.yaml
}

function kube_cmds {
	kubectl get nodes
	kubectl get pods -A
}

function build_docker_images {
	cd ./backstage-fpiva/
	docker build -t backstage-app:v1 .
	minikube image load backstage-app:v1
}

function main {
	start_mini_kube
	sleep 5
	install_argo
	sleep 5
	apply_argo_applications
	sleep 5
	kube_cmds
	sleep 5
	# delete_minikube
}

main
