
# openfaas-go-fn

Update the Kubernetes API server address to your host's in [kind.yml](kind.yml#L6). This is needed for the dev container to communicate with the KinD cluster. Otherwise, kubectl commands against the API server won't work.

Run:

```bash
kind create cluster --config=kind.yml
```

Install OpenFaaS:

```bash
arkade install openfaas
```

```bash
Release "openfaas" does not exist. Installing it now.
NAME: openfaas
LAST DEPLOYED: Fri Nov 26 15:51:12 2021
NAMESPACE: openfaas
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
To verify that openfaas has started, run:

  kubectl -n openfaas get deployments -l "release=openfaas, app=openfaas"
=======================================================================
= OpenFaaS has been installed.                                        =
=======================================================================

# Get the faas-cli
curl -SLsf https://cli.openfaas.com | sudo sh

# Forward the gateway to your machine
kubectl rollout status -n openfaas deploy/gateway
kubectl port-forward -n openfaas svc/gateway 8080:8080 &

# If basic auth is enabled, you can now log into your gateway:
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin

faas-cli store deploy figlet
faas-cli list

# For Raspberry Pi
faas-cli store list \
 --platform armhf

faas-cli store deploy figlet \
 --platform armhf

# Find out more at:
# https://github.com/openfaas/faas

Thanks for using arkade!
```

```bash
# Forward the gateway to your machine
kubectl rollout status -n openfaas deploy/gateway
kubectl port-forward -n openfaas svc/gateway 8080:8080 &
```

```bash
# If basic auth is enabled, you can now log into your gateway:
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin
```

Visit http://127.0.0.1:8080/

```bash
faas-cli store deploy figlet
faas-cli list
```

# Build and deploy your own functino

```bash
faas-cli build -f go-fn.yml
```

Run docker login inside the development container and and update the username and repository name in `go-fn.yml` to yours.

```bash
faas-cli push -f go-fn.yml
```

(Make the DockerHub repository public or remember to set up authentication in KinD to pull images from your newly created DockerHub repository).

```bash
faas-cli deploy -f go-fn.yml

Deploying: go-fn.

Deployed. 202 Accepted.
URL: http://127.0.0.1:8080/function/go-fn
```
