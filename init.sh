#!/bin/bash

set -e

function start_mini_kube {
	echo "================================="
	echo "🎯 Starting Minikube with Addons"
	echo "================================="
	minikube start --addons=ingress,istio,istio-provisioner,metrics-server,ingress-dns,registry --insecure-registry "192.168.0.0/16" --cpus=4
}

function install_argo {
	echo "==================="
	echo "🎯 Installing ArgoCD"
	echo "==================="
	kubectl create ns argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

	echo "============================"
	echo "🎯 Installing Argo Rollouts"
	echo "============================"
	kubectl create namespace argo-rollouts
	kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
}

function build_docker_stable {
	echo "================================="
	echo "🎯 Building Stable Backstage App"
	echo "================================="
	cd ./backstage-app/
	docker build -t backstage-app:v1.stable .
	cd -
}

function build_docker_unstable {
	echo "==================================="
	echo "🎯 Building UNStable Backstage App"
	echo "==================================="

	git apply ./init-files/patch.diff

	cd ./backstage-app/
	docker build -t backstage-app:v1.unstable .
	cd -
}

function push_docker_to_minikube {
	echo "=============================="
	echo "🎯 Pushing images to Minikube"
	echo "=============================="
	minikube image load backstage-app:v1.stable
	minikube image load backstage-app:v1.unstable

	git checkout -- .
}

function apply_argo_applications {
	echo "=============================="
	echo "🎯 Applying Argo Applications"
	echo "=============================="
	kubectl apply -f ./init-files/application-backstage.yaml
	kubectl apply -f ./init-files/application-prometheus.yaml
}

function kube_cmds {
	kubectl get pods -A

	echo "==============================---------------"
	echo "🎯 Getting ArgoCD initial Password to login:"
	echo "============================================="
	kubectl get secrets -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 -d
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

function infos {
	echo "You can see the ArgoCD interface by running:"
	echo ">> kubectl port-forward -n argocd svc/argocd-server 8080:80"
	echo "\n\n\n"

	echo "You can monitor the ArgoRollouts (by having installed the proper kubectl plugin):"
	echo ">> kubectl argo rollouts get rollout backstage-rollout -n my-app -w"
	echo "\n\n\n"
}

function main {
	start_mini_kube
	sleep 5
	install_argo
	sleep 5
	build_docker_stable
	build_docker_unstable
	push_docker_to_minikube
	sleep 5
	apply_argo_applications
	sleep 5
	kube_cmds
	sleep 5
	# delete_minikube
	infos
}

main
