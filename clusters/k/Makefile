.PHONY: all secrets

SECRETS := $(shell grep -r -l "^kind: Secret$$" ./{adjacency,dashboard,external-dns,fluxcdbot,flux-system,kilo,kube-system,matchbox})
SEALED_SECRETS := $(addsuffix -sealed.yaml,$(basename $(SECRETS)))

all: $(SEALED_SECRETS) sealed-secrets-controller-certificate.pem

secrets: $(SEALED_SECRETS)
$(SEALED_SECRETS): $(SECRETS)
	sops -d $$(echo -n $@ | sed 's/-sealed\.yaml$$/.yaml/') | kubeseal --allow-empty-data --format=yaml > $@

sealed-secrets-controller-certificate.pem:
	kubeseal --fetch-cert > $@
