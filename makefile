
cluster-create:
	kind delete cluster
	kind create cluster --config=test/kind.yaml

install-kind:
	cd nidhogg/ && helm dep up && cd ..
	helm upgrade --install --create-namespace nidhogg ./nidhogg --values ./env/kind/nidhogg.yaml --set nidhogg.yggdrasil.targetRevision=$(shell git rev-parse --abbrev-ref HEAD)
	echo "please configure you hosts file to contain a reference for 'local.energioprindelse.dk' to 172.18.0.230 and access the application on https://localhost.energioprindelse.dk/admin/argocd"

install-minikube:
	cd nidhogg/ && helm dep up && cd ..
	helm upgrade --install --create-namespace nidhogg ./nidhogg --values ./env/minikube/nidhogg.yaml --set nidhogg.yggdrasil.targetRevision=$(shell git rev-parse --abbrev-ref HEAD)
	echo "please configure you hosts file to contain a reference for 'local.energioprindelse.dk' to 127.0.0.240 and access the application on https://localhost.energioprindelse.dk:8443/admin/argocd"

uninstall-local: 
	helm uninstall nidhogg
