
Authentication and authorization are both crucial for a platform such as Kubernetes. Authentication ensures users are who they claim to be. Authorization verifies if users have sufficient permission to perform certain operations. Kubernetes supports various authentication and authorization plugins.

The whole chain that going on API server with each request is:

`Authentication -> Authorization -> Admission control (Validating/Mutating requests)`


<h1>Authentication</h1>

Exist several account authentication strategies supported in Kuberentes, from:
- client certificates, 
- bearer tokens, 
- static files to OpenID connect tokens. 
<br>

`More than one option could be chosen and combined with others in authentication chains.`

<h2> Service account TOKEN authentication </h2>

Parse the ca.crt from default token 
```
CERT=$(kubectl get secret default-token-ng29d -o yaml | grep ca.crt | cut -f 2- -d ":" | tr -d " " | base64 -D)
```


Parse the token from default token 
```
TOKEN=$(kubectl get secret --field-selector type=kubernetes.io/service-account-token -o name | grep default-token- | head -n 1 | xargs kubectl get -o 'jsonpath={.data.token}' | base64 -d)
```

Parse the API server endpoint from config
```
APISERVER=$(kubectl config view | grep server | cut -f 2- -d ":" | tr -d " ")
```
<br>

Practice:
```
curl $APISERVER/api -H "Authorization: Bearer $TOKEN" --insecure

curl "https://kubernetes.docker.internal:6443" --header "Authorization: Bearer $TOKEN" -k
    or
curl --cacert cert  "https://kubernetes.docker.internal:6443/api" --header "Authorization: Bearer $TOKEN"


curl --cacert cert  "https://kubernetes.docker.internal:6443/api/v1/configmaps" --header "Authorization: Bearer $TOKEN" | grep \"name\"
```

<br>
<br>
<h2>X509 CLIENT CERTS</h2>

We'll create a user named Nick and generate a client cert for him:

Generate a private key for Nick

```
openssl genrsa -out Nick.key 2048
```

Generate a certificate sign request (.csr) for Nick. Make sure /CN is equal to the username.
```
openssl req -new -key Nick.key -out Nick.csr -subj "/CN=nick"
```
Generate a cert
```
openssl x509 -req -in Nick.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out Nick.crt -days 30
```
Set it into our kubeconfig file
```
kubectl config set-credentials nick --client-certificate=Nick.crt --client-key=Nick.key
kubectl config view
kubectl config set-context nick-context --cluster=docker-desktop --user=nick
```

<br>
<br>
<h2>OpenID connect tokens</h2>

Delegating the identity verification to OAuth2 providers, is a convenient way to manage users. To enable the feature, two required flags have to be set to the API server startUP configuration: --oidc-issuer-url, which indicates the issuer URL that allows the API server to discover public signing keys, and -- oidc-client-id, which is the client ID of your app to associate with your issuer. 
<br>Example:
<br>// start minikube cluster and passing oidc parameters.
 ```
 minikube start --extra-config=apiserver.Authorization.Mode=RBAC --extra-config=apiserver.Authentication.OIDC.IssuerURL=https://accounts.google.com --extra-config=apiserver.Authentication.OIDC.UsernameClaim=email --extra-config=apiserver.Authentication.OIDC.ClientID="140285873781- f9h7d7bmi6ec1qa0892mk52t3o874j5d.apps.googleusercontent.com"
 ```

 After the cluster is started, the user has to log in to the identity provider in order to get access_token, id_token, and refresh_token.
 

For full information, please refer to the official documentation https:/​/​kubernetes.​io/​docs/ admin/​authentication/​#configuring-​the-​api-​server. 