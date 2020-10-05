IMAGE_NAME ?= "ghcr.io/infomaniak/cert-manager-webhook-infomaniak"
IMAGE_TAG ?= "latest"
NAMESPACE ?= "cert-manager-infomaniak"

OUT := $(shell pwd)/_out

KUBEBUILDER_VERSION=2.3.1
KUBEBUILDER_URL=https://github.com/kubernetes-sigs/kubebuilder/releases/download/v$(KUBEBUILDER_VERSION)/kubebuilder_$(KUBEBUILDER_VERSION)_linux_amd64.tar.gz
KUBEBUILDER_TGZ=$(OUT)/kubebuilder/kubebuilder_$(KUBEBUILDER_VERSION)_linux_amd64.tar.gz
KUBEBUILDER_BIN=$(OUT)/kubebuilder/bin

$(shell mkdir -p "$(KUBEBUILDER_BIN)")

$(KUBEBUILDER_TGZ):
	curl -sfL $(KUBEBUILDER_URL) -o $(KUBEBUILDER_TGZ)

prepare: $(KUBEBUILDER_TGZ)
	tar xvzf $(KUBEBUILDER_TGZ) --strip-components=1 -C _out/kubebuilder

$(KUBEBUILDER_BIN)/etcd: prepare
$(KUBEBUILDER_BIN)/kube-apiserver: prepare
$(KUBEBUILDER_BIN)/kubebuilder: prepare
$(KUBEBUILDER_BIN)/kubectl: prepare

test: $(KUBEBUILDER_BIN)/etcd $(KUBEBUILDER_BIN)/kube-apiserver $(KUBEBUILDER_BIN)/kubebuilder $(KUBEBUILDER_BIN)/kubectl
	go test -v .

build:
	docker build -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

clean:
	rm -rf _out apiserver.local.config testdata/infomaniak/*.json testdata/infomaniak/*.yaml

deploy: rendered-manifest.yaml
	kubectl apply -f "deploy/rendered-manifest.yaml"

.PHONY: rendered-manifest.yaml
rendered-manifest.yaml:
	helm template \
		infomaniak-webhook \
		--namespace $(NAMESPACE) \
		--set image.repository=$(IMAGE_NAME) \
		--set image.tag=$(IMAGE_TAG) \
		deploy/infomaniak-webhook > "deploy/rendered-manifest.yaml"
