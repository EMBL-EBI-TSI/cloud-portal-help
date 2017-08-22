# Developer tools and documentation for the cloud-portal

- `appliance_configuration` directory contains the input and parameter configurations to deploy some of the portal appliance, using the Embassy TSI OpenStack tenancies.

|Portal apps configuration for|
|---|
|cpa-chipster|
|cpa-docker-container|
|cpa-instance|
|cpa-monitoring|

- `API_calls.md` contains a few API call examples.

- `deploy.sh` is a bash script that can be used for destroy failed cloud portal deployment.  
The use is self explicative, it can contact one of the `dev`, `master` or `localhost` endpoints, adding one of the previous word as argument (or without any argument it will try to stop & destroy a deployment in `dev`):  

```
./destroy.sh [dev/master/localhost]
```

It requires only the ID of the deployment and the `jwt` authentication token (See `API_calls.md` for how to obtain it).  

- `kibana.md` contains information about the TSI kibana endpoint.  
