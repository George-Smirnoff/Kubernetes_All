I've faced same problem with my registry then i tried the solution listed below from a blog page. It works.

<h2>Step 1: Listing catalogs</h2>

You can list your catalogs by calling this url:

http://YourPrivateRegistyIP:5000/v2/_catalog
Response will be in the following format:

{
  "repositories": [
    <strong><em>\<name\></em></strong>,
    ...
  ]
}

<strong>Example:</strong><br>
<strong>curl -Lkv -u user1:passwd 'https://localhost:5000/v2/_catalog' -o registry</strong>

<h2>Step 2: Listing tags for related catalog</h2>

You can list tags of your catalog by calling this url:

http://YourPrivateRegistyIP:5000/v2/<strong><em>\<name\></em></strong>/tags/list
Response will be in the following format:

{
"name": <strong><em>\<name\></em></strong>,
"tags": [
    <tag>,
    ...
]
}

<strong>Example:</strong><br>
<strong>curl -Lk -u user1:passwd 'https://localhost:5000/v2/alpine/tags/list' -o registry</strong>

<h2>Step 3: List manifest value for related tag</h2>

You can run this command in docker registry container:

curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET http://localhost:5000/v2/<strong><em>\<name\></em></strong>/manifests/<tag> 2>&1 | grep Docker-Content-Digest | awk '{print ($3)}'
Response will be in the following format:

sha256:6de813fb93debd551ea6781e90b02f1f93efab9d882a6cd06bbd96a07188b073
Run the command given below with manifest value:

curl -v --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE http://127.0.0.1:5000/v2/<strong><em>\<name\></em></strong>/manifests/sha256:6de813fb93debd551ea6781e90b02f1f93efab9d882a6cd06bbd96a07188b073

<strong>Example:</strong><br>
<strong>curl -u user1:passwd -Lk --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET 'https://localhost:5000/v2/alpine/manifests/latest' 2>&1 | jq .config

curl -u user1:passwd -kL --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE http://127.0.0.1:5000/v2/alpine/manifests/sha256:6678c7c2e56c970388f8d5a398aa30f2ab60e85f20165e101053c3d3a11e6663
</strong>

<h2>Step 4: Delete marked manifests</h2>

Run this command in your docker registy container:

bin/registry garbage-collect  /etc/docker/registry/config.yml  
Here is my config.yml

root@c695814325f4:/etc# cat /etc/docker/registry/config.yml
```version: 0.1
log:
  fields:
  service: registry
storage:
    cache:
        blobdescriptor: inmemory
    filesystem:
        rootdirectory: /var/lib/registry
    delete:
        enabled: true
http:
    addr: :5000
    headers:
        X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
```

