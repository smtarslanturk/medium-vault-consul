# run this codes in vault container-pod
k exec -it -n vault pods/vault-0 -- sh

# init, unseal, login as root, create process for Vault 
vault status 

mkdir /vault/tmp &&
vault operator init -key-shares=1 -key-threshold=1 > /vault/tmp/vault-init.txt &&
cat /vault/tmp/vault-init.txt | grep "Unseal Key" | cut -d' ' -f4 > /vault/tmp/vault-unseal-key.txt &&
cat /vault/tmp/vault-init.txt | grep "Initial Root Token" | cut -d' ' -f4 > /vault/tmp/vault-root-token.txt &&
vault operator unseal "$(cat /vault/tmp/vault-unseal-key.txt)" &&
vault login "$(cat /vault/tmp/vault-root-token.txt)"
vault status

# Show vault-unseal-key and vault-root-token
cat /vault/tmp/vault-unseal-key.txt
cat /vault/tmp/vault-root-token.txt

#NOT: saved these keys in a safe location. We can neeed these keys same status like pods restart.
unsealKey: o6ICuj0GNm57xxxxxxx
rootToken: hvs.Kkxxxxxx