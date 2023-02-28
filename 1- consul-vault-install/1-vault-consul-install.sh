# Create ns
kubectl create ns hashicorp
kubectl create ns vault
kubectl create ns app

# Add hashicorp helm repo to local 
helm search repo hashicorp/consul
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo list 
helm repo update 

# Install Consul on Minikube
cd 1-consul-vault-install/consul-helm/ 
helm install consul hashicorp/consul -n hashicorp --values values.yaml

# Intall Vault on Minikube
helm install vault hashicorp/vault -n vault

# Acces Vault and Consul Web UI from Localhost via Port-Forward 
k port-forward -n demo-hashicorp pods/consul-server-0 8500:8500
k port-forward -n demo-vault pods/vault-0 8200:8200
--------------------------------------------------------------------------------------------
# NOT: Eger vault auto complatationu aktif etmek istiyorsaniz asagidaki komutu calistirin: 
vault -autocomplete-install && source $HOME/.bashrc