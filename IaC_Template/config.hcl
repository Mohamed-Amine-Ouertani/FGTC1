storage "raft" { 
  path    = "./vault/data" #You need to add the /vault/data directory to the current directory
  node_id = "node1"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = "true" # The listener stanza disables TLS (tls_disable = "true"). In production, Vault should always use TLS to provide secure communication between clients and the Vault server
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
ui = true
