## Up and Running

To run the server:

1. Install dependencies and compile: 
  ```
  mix do deps.get, compile 
  ```
2. Run the server:  

   * With developing settings:  

  ```
  mix phoenix.server
  ```  

   * With production settings:  
      To view the effect for every change you made in production mode, you have to be compiled explicitly.  
 

  ```
  MIX_ENV=prod mix compile
  MIX_ENV=prod mix phoenix.server
  ```

## Test with cURL request

*Get Content*
  ```
  curl -i http://localhost:8080/poll
  ```

*Create*
  ```bash
  curl -i -H "Content-Type:application/json" -d '{"name":"Name"}' http://localhost:8080/poll"
  ``` 
## Test with mix

  ```bash
  mix Test
  ```

## Integrate proxy server for Google Cloud SQL on GKE

To set up applications on Google Container Engine and use Cloud SQL to store your data, you have to set up a pod on GKE, running two containers: your application and a Cloud SQL proxy server. Your application will connect Cloud SQL through this proxy server.

### Set up Kubernetes:
1. Get Kubernetes: `gcloud components install kubectl`

2. Create a Cloud SQL instances. Create a user account for you application.

3. Create a GKE container cluster

4. Let `kubectl` could login your clusters:
	
  gcloud doesn’t know you have cluster now. If you use `gcloud container clusters list` to get clusters info, you will find gcloud can’t get your clusters. **You have to first get credentials for this cluster**:

  ```bash
  gcloud container clusters get-credentials [YOUR CLUSTER NAME HERE]
  ```

  gcloud command can now find the clusters. Use `kubectl config get-contexts` to query kubernetes context. There is the new context set to default for this cluster.

### Building docker images:

Before you build the docker image, you have to make sure your application connect to `127.0.0.1:3306`. The Cloud SQL proxy server will run at `127.0.0.1:3306` in the pods, which is local to your application container. 

1. `docker build --no-cache -t [IMAGE NAME] .`
2. `docker tag [IMAGE NAME] gcr.io/[YOUR PROJECT NAME]/[IMAGE NAME ON gcr.io]`
3. push your image to Google Container Registry:

  ```bash
  gcloud docker push gcr.io/[YOUR PROJECT NAME]/[IMAGE NAME]
  ```

### Get credentials for Cloud SQL proxy server and register them with Kubernetes
1. Create a key for a service account (with Editor role) in JSON format. The key will be downloaded to your computer.

2. Register the key downloaded in previous step with `kubectl`:

  ```bash
  kubectl create secret generic cloud-oauth-credentials --from-file=credentials.json=[YOUR KEYFILE PATH]
  ```

3. Create the secrets to access the database you create. Provide the username and password your set here:

  ```basg
  kubectl create secret generic cloudsql --from-literal=username=[YOUR CLOUDSQL USERNAME] --from-literal=password=[YOUR CLOUDSQL PASSWORD]
  ```

### Create pod and service with config files
The last and most important step, you have to create pod for GKE.

#### Create pod
1. Create a new file for pod config like `deployment.yml`. Assign the image source like:
  
  ```bash
  image:"gcr.io/mirrormedia-1470651750304/mmrest-ex"
  ```

2. Deploy the proxy server with sidecar pattern. Notice: **Do not change the path for `--dir`, `-credential_file` or paths in volumneMounts.**
  
  ```
  - name: cloudsql-proxy
          image: b.gcr.io/cloudsql-docker/gce-proxy:1.05
          command: ["/cloud_sql_proxy", "--dir=/cloudsql",
                    "-instances=[YOUR CLOUD SQL INSTANCE NAME]=tcp:3306",
                    "-credential_file=/secrets/cloudsql/credentials.json"]
          volumeMounts:
              - name: cloudsql-oauth-credentials
                mountPath: /secrets/cloudsql
                readOnly: true
              - name: ssl-certs
                mountPath: /etc/ssl/certs
              - name: cloudsql
                mountPath: /cloudsql
  ```

3. Add the volumes as-is:

  ```bash
  volumes:
      - name: cloudsql-oauth-credentials
        secret:
          secretName: cloudsql-oauth-credentials
      - name: ssl-certs
        hostPath:
          path: /etc/ssl/certs
      - name: cloudsql
        emptyDir:
  ```

4. The full `deployment.yml` should look like:
  ```bash
  apiVersion: v1
  kind: Pod
  metadata:
      name: [YOUR POD NAME]
      labels:
          name: [YOUR POD NAME]
  spec:
      containers:
          - name: [CONTAINER NAME]
            image: "gcr.io/[YOUR PROJECT NAME]/[IMAGE NAME]"
            ports:
            - containerPort: 80

          - name: cloudsql-proxy
            image: b.gcr.io/cloudsql-docker/gce-proxy:1.05
            command: ["/cloud_sql_proxy", "--dir=/cloudsql",
                      "-instances=[YOUR CLOUD SQL INSTANCE NAME]=tcp:3306",
                      "-credential_file=/secrets/cloudsql/credentials.json"]
            volumeMounts:
                - name: cloudsql-oauth-credentials
                  mountPath: /secrets/cloudsql
                  readOnly: true
                - name: ssl-certs
                  mountPath: /etc/ssl/certs
                - name: cloudsql
                  mountPath: /cloudsql
      volumes:
          - name: cloudsql-oauth-credentials
            secret:
              secretName: cloudsql-oauth-credentials
          - name: ssl-certs
            hostPath:
              path: /etc/ssl/certs
          - name: cloudsql
            emptyDir:
  ```

5. Create the pods with `deployment.yml`:

  ```bash 
  kubectl create -f deployment.yml
  ```

If successful, your pods is running. Check it with:

  ```bash
  kubectl describe pod [YOUR POD NAME]
  ```

#### Create service

Your application is now inaccessible using external IP. **You have to forward port, or create service first.** Port forwarding:
  ```bash
  kubectl port-forward [YOUR CONTEXT NAME] 8080:80
  ```
then you could request `localhost:8080` to test your application.

To create service, make a new file like `service.yml`. *IMPORTANT: in `selector` make sure you put right pod name you want to expose.* `service.yml` should like:

  ```bash
  apiVersion: v1
  kind: Service
  metadata:
    name: [SERVICE NAME]
  spec:
    selector:
      name: [YOUR POD NAME]
    ports:
      - protocol: TCP
        port: 8080
        targetPort: 8080
  ```

Create service with:
  ```bash
  kubectl expose -f service.yml
  ```
You could get the external IP for your app by `kubectl get services`. Access your app using this IP and port you set in `service.yml`.
=======
## Development

### Up and Running

To run the server:

 1. Install dependencies and compile: 
 ```
 mix do deps.get, compile 
 ```
 2. Run the server:  

   * With developing settings:  

 ```
 mix phoenix.server
 ```  

   * With production settings:  
      To view the effect for every change you made in production mode, you have to be compiled explicitly.  
 

 ```
 MIX_ENV=prod mix compile
 MIX_ENV=prod mix phoenix.server
 ```

### Test with cURL request

*Get Content*
```
curl -i http://localhost:8080/poll
```

*Create*
```bash
curl -i -H "Content-Type:application/json" -d '{"name":"Name"}' http://localhost:8080/poll"
``` 
### Test with mix

```bash
mix Test
```
