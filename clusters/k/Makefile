.PHONY: all secrets

SECRETS := $(shell grep -r -l "^kind: Secret$$" ./{adjacency,dashboard,external-dns,kilo,matchbox})
SEALED_SECRETS := $(addsuffix -sealed.json,$(basename $(SECRETS)))

all: $(SEALED_SECRETS) sealed-secrets-controller-certificate.pem

secrets: $(SEALED_SECRETS)
$(SEALED_SECRETS): $(SECRETS)
	sops -d $$(echo -n $@ | sed 's/-sealed\.json$$/.yaml/') | kubeseal --allow-empty-data > $@

sealed-secrets-controller-certificate.pem:
	kubeseal --fetch-cert > $@
