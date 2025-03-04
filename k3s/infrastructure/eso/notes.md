# External Secret Operator

```text
helm install external-secrets external-secrets/external-secrets \
    --namespace=external-secrets \
    --create-namespace \
    --set installCRDs=true
```

```text
❯ kubectl get all -n external-secrets
NAME                                                    READY   STATUS    RESTARTS   AGE
pod/external-secrets-55dbcddd4-t85q4                    1/1     Running   0          9h
pod/external-secrets-cert-controller-7b7f558bd7-bv4nl   1/1     Running   0          9h
pod/external-secrets-webhook-7f8d47f565-sxt6q           1/1     Running   0          9h

NAME                               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/external-secrets-webhook   ClusterIP   10.43.220.20   <none>        443/TCP   9h

NAME                                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/external-secrets                   1/1     1            1           9h
deployment.apps/external-secrets-cert-controller   1/1     1            1           9h
deployment.apps/external-secrets-webhook           1/1     1            1           9h

NAME                                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/external-secrets-55dbcddd4                    1         1         1       9h
replicaset.apps/external-secrets-cert-controller-7b7f558bd7   1         1         1       9h
replicaset.apps/external-secrets-webhook-7f8d47f565           1         1         1       9h
```
```text
export VAULT_ADDR='https://vault.uclab8.net:8200'
export VAULT_CACERT='/Users/antonis/.config/certca/ca.crt'
```
```text
vault login -method=userpass \
    username=<username> \
    password=<password>

WARNING! The VAULT_TOKEN environment variable is set! The value of this
variable will take precedence; if this is unwanted please unset VAULT_TOKEN or
update its value accordingly.

Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  <token>
token_accessor         <token_accessor>
token_duration         768h
token_renewable        true
token_policies         ["admin" "default"]
identity_policies      []
policies               ["admin" "default"]
token_meta_username    <username>
```
```text
❯ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.18.4
Build Date      2025-01-29T13:57:54Z
Storage Type    file
Cluster Name    vault-cluster-5c71a2e8
Cluster ID      1cdb3cce-a97a-c3ef-dc33-9385e1eae1b3
HA Enabled      false
```



```text
vault secrets enable -path=secret/ kv
```
```text
```text
vault kv put -mount=secret db-creds username=<username> password=<password>
==== Secret Path ====
secret/data/db-creds
```

```text
kubectl create secret generic vault-token --from-literal=token=<token>
secret/vault-token created
```

```text
k -n external-secrets create secret generic vault-ca-cert --from-file=ca.crt=vault-ca.crt
secret/vault-ca-cert created
```
```yaml
# cluster-secret-store.yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "https://vault.uclab8.net:8200"
      path: "secret"
      version: "v2"
      caProvider:
        type: Secret
        name: vault-ca-cert
        key: ca.crt
        namespace: external-secrets
      auth:
        tokenSecretRef:
          name: vault-token
          key: token
          namespace: external-secrets
```

```text
 k get clustersecretstores.external-secrets.io
NAME            AGE    STATUS   CAPABILITIES   READY
vault-backend   115m   Valid    ReadWrite      True
```


```yaml
# db-creds.yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: test-db-creds
  namespace: external-secrets
spec:
  refreshInterval: "15s"
  secretStoreRef:
    name: vault-backend
    kind: ClusterSecretStore
  target:
    name: demo-db-creds
    creationPolicy: Owner
  data:
    - secretKey: username
      remoteRef:
        key: db-creds
        property: username
    - secretKey: password
      remoteRef:
        key: db-creds
        property: password
```

```text
k get externalsecrets.external-secrets.io
NAME            STORETYPE            STORE           REFRESH INTERVAL   STATUS         READY
test-db-creds   ClusterSecretStore   vault-backend   15s                SecretSynced   True

```
