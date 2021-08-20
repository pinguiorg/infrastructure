.PHONY: all secrets

CLUSTER ?= k
SECRETS := $(shell grep -r -l "^kind: Secret$$" ./apps/$(CLUSTER)/{adjacency,binomial,dashboard,external-dns,fluxcdbot,flux-system,kilo-ui,matchbox,monitoring})
SEALED_SECRETS := $(addsuffix -sealed.yaml,$(basename $(SECRETS)))
MONITORING_MANIFESTS = $(shell find apps/base/monitoring/setup apps/base/monitoring -maxdepth 1 -type f -name '*.yaml' | sed 's|^apps/base/monitoring/||g' | grep -v 'kustomization\.yaml$$' | grep -v '-secret.yaml$$' | grep -v '^patch-.*.yaml$$')

all: $(SEALED_SECRETS) clusters/$(CLUSTER)/sealed-secrets-controller-certificate.pem

secrets: $(SEALED_SECRETS)
$(SEALED_SECRETS): $(SECRETS)
	sops -d $$(echo -n $@ | sed 's/-sealed\.yaml$$/.yaml/') | kubeseal --allow-empty-data --format=yaml --cert=clusters/$(CLUSTER)/sealed-secrets-controller-certificate.pem > $@

clusters/$(CLUSTER)/sealed-secrets-controller-certificate.pem:
	kubeseal --fetch-cert > $@

apps/base/monitoring:
	mkdir -p apps/base/monitoring && curl -L https://github.com/prometheus-operator/kube-prometheus/tarball/main | tar xvz -C monitoring --wildcards '*/manifests/' --strip-components=2
	mv apps/base/monitoring/grafana-dashboardDatasources.yaml monitoring/grafana-dashboardDatasources-secret.yaml
	sops -i -e apps/base/monitoring/grafana-dashboardDatasources-secret.yaml
	sops -i -e apps/base/monitoring/alertmanager-secret.yaml

apps/base/monitoring/kustomization.yaml: apps/base/monitoring apps/base/monitoring/kustomization.yaml.tmpl $(addprefix apps/base/monitoring/,$(MONITORING_MANIFESTS))
	cat apps/base/monitoring/kustomization.yaml.tmpl | sed "s|\$$RESOURCES|$$(echo -n $(foreach manifest,$(MONITORING_MANIFESTS),\"$(manifest)\",) | sed 's/,$$//')|g" > $@
