#!/bin/bash

set -e

function start_mini_kube {
	# MINIKUBE_STATUS=$(minikube status -o json | jq -r '.[].Host' | sort -u)
	# if [ "$(minikube status -o json | jq -r '.data.message' | grep "minikube start" 2>/dev/null)" == "To start a cluster, run: \"minikube start\"" ]; then
	echo "Starting Minikube with Addons"
	minikube start --addons=ingress,istio,istio-provisioner,metrics-server,ingress-dns,registry
	# else
	# 	echo "Minikube is already running"
	# fi
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

function kube_cmds {
	kubectl get nodes
	kubectl get pods -A
}

# function build_docker_images {
#
# }

# function check_argo_installed {
# 	ARGO_INSTALLED=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
# 	ARGO_ROLLOUTS_INSTALLED=$(kubectl get pods -n argo-rollouts -l app.kubernetes.io/name=argo-rollouts -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
#
# 	if [ -z "$ARGO_INSTALLED" || -z "$ARGO_ROLLOUTS_INSTALLED" ]; then
# 		echo "ArgoCD is not installed"
# 		intsall_argo
# 	else
# 		echo "ArgoCD is already installed"
# 	fi
# }

function main {
	start_mini_kube
	install_argo
	kube_cmds
	# check_argo_installed
	# delete_minikube
}

main
