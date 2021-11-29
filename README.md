
# openfaas-go-fn

Sample OpenFaaS Go Function (classic template) ready to run as a [Docker Dev Environment](https://docs.docker.com/desktop/dev-environments/).

## Getting started

This repository is configured to run as a Docker Dev Environment using the base image specified [here](https://github.com/felipecruz91/openfaas-go-fn/blob/main/.docker/config.json#L2).

Once you create a Docker Dev Environment, you won't have to download any further tools or dependencies to play around with this example.

You will have all the developer tooling to develop, build, and push your OpenFaaS function, baked within the development container.
Note that you can also use `kind` to create a Kubernetes cluster in Docker to provision the infrastructure where to install OpenFaaS.
> Update the Kubernetes API server address to your host's in [kind.yml](kind.yml#L6). 
This is needed for the dev container to communicate with the KinD cluster. Otherwise, kubectl commands against the API server won't work.

## Provision the Kubernetes cluster

Create the Kubernetes cluster in Docker

```bash
kind create cluster --config=kind.yml
```

Install OpenFaaS

```bash
arkade install openfaas
```

Forward the gateway to your machine
```bash
kubectl rollout status -n openfaas deploy/gateway
kubectl port-forward -n openfaas svc/gateway 8080:8080 &
```

Login to OpenFaaS Gateway
```bash
# If basic auth is enabled, you can now log into your gateway:
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin
```

Visit http://127.0.0.1:8080/ to see the OpenFaaS Gateway.

### Build and deploy your function

Build the function

```bash
faas-cli build -f go-fn.yml
```

Push the function. Make sure you run `docker login` inside the development container and update the username and repository name in `go-fn.yml` to yours.
Remember to set up authentication in KinD to pull images from your newly created DockerHub repository or, otherwise, make the DockerHub repository public.

```bash
faas-cli push -f go-fn.yml
```

Deploy the function to the OpenFaaS Gateway

```bash
faas-cli deploy -f go-fn.yml
```
