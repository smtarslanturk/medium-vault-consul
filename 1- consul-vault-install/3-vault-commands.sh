# run this script in vault container
k exec -it -n vault pods/vault-0 -- sh

######################################################
# Vaul Secrets Engines Commands
# Var olan secret-engineleri listele
vault secrets list

# demoKv1 adında kv (key-value) turunde secret-engine olustur. 
vault secrets enable -path=demoKv1 kv

# demoSsh adında ssh turunde secret-engine olustur.
vault secrets enable -path demoSsh ssh

# demoAws adında ssh turunde secret-engine olustur.
vault secrets enable -path demoAws aws

# olusturulan secret-engineleri detaylı sekilde goster. 
vault secrets list -detailed

vault kv get -mount=demo-kv -format=json path1 | jq .data.data
# demoKv2 adında kv turunde versiyon-2 secret-engine olustur.
vault secrets enable -version=2 -path="demoKv2" kv

# demoKv2 secret-engine icerisinde path1 adında secret olustur ve icerisine key value koy.
vault kv put demoKv2/path1 key1=value1

# var olan secret-engineleri listele. 
vault secrets list

# demoKv2 secret-engine icesindeki secretları listele.
vault kv list demoKv2/

# path1 secretında bulunan degerleri listele.
vault kv get demoKv2/path1

# path1 secretında bulunan degerleri json formatında listele.
vault kv get -format=json demoKv2/path1

# path1 secreti icerisine key2 value degerlerini ekle. 
vault kv patch demoKv2/path1 key2=value2
# path1 secretında bulunan degerleri listele.
vault kv get demoKv2/path1

# demoSsh ve demoKv1 secret-enginelerini sil. 
vault secrets disable demoSsh
vault secrets disable demoKv1

######################################################
# Vaul Token Commands
# policy1'in match edildigi yeni bir token olustur. 
vault token create -policy=policy1 

# olusturulan polcinin durumunu gozlemle. 
vault token lookup <policyToken>

# olusturulan policy sil. 
vault token revoke <policyToken>

######################################################
# Vault Authentication Methods Commands
# Var olan Authentication Methodlari listele. 
vault auth list

# github adinda github turunde Authentication Method'u aktif et. 
vault auth enable github

# kubernetes adinda k8s turunde Authentication Method'u aktif et.
vault auth enable kubernetes

# demo-k8s adinda k8s turunde Authentication Method'u aktif et.
vault auth enable --path="demo-k8s" kubernetes

# github adindaki Authentication Method'u sil. 
vault auth disable github

# kubernetes adindaki Authentication Method'u sil.
vault auth disable kubernetes

# varolan Authentication Methodlari listele.
vault auth list

######################################################
# Vault ACL Policies Commands 
# varolan policyleri listele.
vault policy list

# policy1 adinda policy yaz ve demoKv2 secret-enginesine read, list yetkisi ver.
vault policy write policy1 - <<EOH
path "demoKv2/*" {
  capabilities = ["read","list"]
}
EOH

# policy1 adinda olusturulan policy'nin yetkisini gor. 
vault policy read policy1

# varolan policyleri listele.
vault policy list

######################################################
# configure the Kubernetes authentication method
vault write auth/demo-k8s/config \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

######################################################
# demo-k8s adindaki Authentication Method'a demo-role1 adındaki rolu ata. 
vault write auth/demo-k8s/role/demo-role1 \
        bound_service_account_names=demo-consul-sa \
        bound_service_account_namespaces=test \
        policies=demo-policy1 \
        ttl=100h