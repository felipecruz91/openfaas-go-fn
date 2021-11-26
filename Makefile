all: create-cluster install-openfaas forward-gateway login-gateway build-fn push-fn deploy-fn

create-cluster:
	kind create cluster --config=kind.yml

install-openfaas:
	arkade install openfaas

# Forward the gateway to your machine
forward-gateway:
	kubectl rollout status -n openfaas deploy/gateway
	kubectl port-forward -n openfaas svc/gateway 8080:8080 &

login-gateway:
	PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
	echo -n $PASSWORD | faas-cli login --username admin --password-stdin

build-fn:
	faas-cli build -f go-fn.yml

push-fn:
	faas-cli push -f go-fn.yml

deploy-fn:
	faas-cli deploy -f go-fn.yml

delete-cluster:
	kind delete cluster	

.PHONY: create-cluster install-openfaas forward-gateway login-gateway build-fn push-fn deploy-fn delete-cluster
