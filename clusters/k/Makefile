.PHONY: all secrets

SECRETS := $(shell grep -r -l "^kind: Secret$$" ./{adjacency,binomial,dashboard,external-dns,fluxcdbot,flux-system,kilo,kube-system,matchbox,monitoring})
SEALED_SECRETS := $(addsuffix -sealed.yaml,$(basename $(SECRETS)))
MONITORING_MANIFESTS := $(shell find monitoring -type f -regex '.*\.yaml$$' | sed 's|^monitoring/||g' | grep -v 'kustomization\.yaml$$' | grep -v '^alertmanager-secret.yaml$$' | grep -v '^patch-.*.yaml$$')

all: $(SEALED_SECRETS) sealed-secrets-controller-certificate.pem

secrets: $(SEALED_SECRETS)
$(SEALED_SECRETS): $(SECRETS)
	sops -d $$(echo -n $@ | sed 's/-sealed\.yaml$$/.yaml/') | kubeseal --allow-empty-data --format=yaml > $@

sealed-secrets-controller-certificate.pem:
	kubeseal --fetch-cert > $@

monitoring:
	mkdir -p monitoring && curl -L https://github.com/prometheus-operator/kube-prometheus/tarball/main | tar xvz -C monitoring --wildcards '*/manifests/' --strip-components=2
	sops -i -e monitoring/alertmanager-secret.yaml

monitoring/kustomization.yaml: monitoring monitoring/kustomization.yaml.tmpl $(addprefix monitoring/,$(MONITORING_MANIFESTS)) monitoring/alertmanager-secret-sealed.yaml monitoring/patch-alertmanager-secret-sealed.yaml
	cat monitoring/kustomization.yaml.tmpl | sed "s|\$$RESOURCES|$$(echo -n $(foreach manifest,$(MONITORING_MANIFESTS),\"$(manifest)\",) | sed 's/,$$//')|g" > $@
