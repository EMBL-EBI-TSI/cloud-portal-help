> **Note**
> The EBI Cloud Portal has been retired and its code base is no longer updated. If you would like to contact the Cloud Portal authors, please leave us feedback via [the EBI contact form](https://www.ebi.ac.uk/about/contact/support/other) mentioning the EBI Cloud Portal in the Subject.

# Developer tools and internal documentation for the EMBL-EBI Cloud Portal

- `appliance_configuration` directory contains the input and parameter configurations to deploy some of the portal appliance, using the Embassy TSI OpenStack tenancies.

|Portal apps configuration for|
|---|
|cpa-chipster|
|cpa-docker-container|
|cpa-docker-galaxy|
|cpa-instance|
|cpa-monitoring|

- `API_calls.md` contains a few API call examples.

- `deploy.sh` is a bash script that can be used for destroy failed cloud portal deployment.  
The use is self explicative, it can contact one of the `dev`, `master` or `localhost` endpoints, adding one of the previous word as argument (or without any argument it will try to stop & destroy a deployment in `dev`):  
`. destroy.sh [dev/master/localhost]`  
or:  
`source destroy.sh [dev/master/localhost]`  
It requires only the ID of the deployment and the `jwt` authentication token (See `API_calls.md` for how to obtain it).  
The `jwt` token, can be also defined as an environment variable named `jwt`, and it will not be required by the script.

- `kibana.md` contains information about the TSI kibana endpoint.  

Public documentation for the EMBL-EBI Cloud portal available [here](https://readthedocs.org/projects/embl-ebi-cloud-portal-documentation)
