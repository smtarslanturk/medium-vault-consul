# Consul poduna exec olunur. 
kubectl exec -it -n hashicorp consul-server-0 -- sh

# Consul'a degerler yazilir. 
consul kv put apps/example/serverPort "8080"
consul kv put apps/example/fooEnabled true
consul kv put apps/example/dbUsername "db-username"

# Yazilan degerler okunur. 
consul kv get apps/example/serverPort
consul kv get apps/example/fooEnabled
consul kv get apps/example/dbUsername