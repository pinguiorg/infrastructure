.PHONY: all secrets test

CLUSTER ?= k
SECRETS := $(shell grep -r -l "^kind: Secret$$" $(addprefix apps/$(CLUSTER)/,adjacency binomial cert-manager dashboard external-dns fluxcdbot flux-system kilo-ui kube-system oauth2-proxy matchbox monitoring unpoller))
SEALED_SECRETS := $(addsuffix -sealed.yaml,$(basename $(SECRETS)))
MONITORING_MANIFESTS = $(shell find apps/base/monitoring/setup apps/base/monitoring -maxdepth 1 -type f -name '*.yaml' | sed 's|^apps/base/monitoring/||g' | grep -v 'kustomization\.yaml$$' | grep -v '-secret.yaml$$' | grep -v '^patch-.*.yaml$$')
INGRESS_NGINX_MANIFESTS = $(shell find apps/base/ingress-nginx/manifests -maxdepth 1 -type f -name '*.yaml' | sed 's|^apps/base/ingress-nginx/manifests/||g' | grep -v 'kustomization\.yaml$$' | grep -v '-secret.yaml$$' | grep -v '^patch-.*.yaml$$')

TEST_IMAGE := stefanprodan/kube-tools:v1.7.1
KUSTOMIZE_VER ?= 4.2.0
CONTAINERIZE_TEST ?= true
TEST_PREFIX :=
TEST_SUFIX :=
ifeq ($(CONTAINERIZE_TEST), true)
	TEST_PREFIX := docker run --rm \
		-it \
		-v $(shell pwd):/infrastructure \
		-w /infrastructure \
		$(TEST_IMAGE) '
	TEST_SUFIX := ' '' $(KUSTOMIZE_VER)
endif

all: $(SEALED_SECRETS) clusters/$(CLUSTER)/sealed-secrets-controller-certificate.pem

secrets: $(SEALED_SECRETS)
$(SEALED_SECRETS): $(SECRETS)
	sops -d $$(echo -n $@ | sed 's/-sealed\.yaml$$/.yaml/') | kubeseal --allow-empty-data --format=yaml --cert=clusters/$(CLUSTER)/sealed-secrets-controller-certificate.pem > $@

clusters/$(CLUSTER)/sealed-secrets-controller-certificate.pem:
	kubeseal --fetch-cert > $@

test:
	@$(TEST_PREFIX) \
		for k in $$(grep -r -l "^kind: Kustomization$$" $(addsuffix /$(CLUSTER), apps clusters) | grep "kustomization\.yaml$$"); do \
			echo "testing $$k"; \
			kustomize build $$(dirname $$k) > /dev/null && \
			kustomize build $$(dirname $$k) | kubeconform --ignore-missing-schemas --strict; \
		done \
	$(TEST_SUFIX)

apps/base/monitoring:
	mkdir -p apps/base/monitoring && curl -L https://github.com/prometheus-operator/kube-prometheus/tarball/main | tar xvz -C monitoring --wildcards '*/manifests/' --strip-components=2
	mv apps/base/monitoring/grafana-dashboardDatasources.yaml monitoring/grafana-dashboardDatasources-secret.yaml
	sops -i -e apps/base/monitoring/grafana-dashboardDatasources-secret.yaml
	sops -i -e apps/base/monitoring/alertmanager-secret.yaml

apps/base/monitoring/kustomization.yaml: apps/base/monitoring apps/base/monitoring/kustomization.yaml.tmpl $(addprefix apps/base/monitoring/,$(MONITORING_MANIFESTS))
	cat apps/base/monitoring/kustomization.yaml.tmpl | sed "s|\$$RESOURCES|$$(echo -n $(foreach manifest,$(MONITORING_MANIFESTS),\"$(manifest)\",) | sed 's/,$$//')|g" > $@

apps/base/ingress-nginx/manifests:
	mkdir -p $@ && out=$$(mktemp -d) && echo $$out && echo -e > $$out/kustomization.yaml \
	"apiVersion: kustomize.config.k8s.io/v1beta1\n\
	kind: Kustomization\n\
	resources:\n\
	- https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/baremetal/deploy.yaml" && \
	kustomize build $$out -o $@

apps/base/ingress-nginx/kustomization.yaml: apps/base/ingress-nginx/manifests apps/base/ingress-nginx/kustomization.yaml.tmpl $(addprefix apps/base/ingress-nginx/manifests/,$(INGRESS_NGINX_MANIFESTS))
	cat apps/base/ingress-nginx/kustomization.yaml.tmpl | sed "s|\$$RESOURCES|$$(echo -n $(foreach manifest,$(INGRESS_NGINX_MANIFESTS),\"manifests/$(manifest)\",) | sed 's/,$$//')|g" > $@
