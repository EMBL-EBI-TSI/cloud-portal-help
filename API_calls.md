# API calls, how to:

## Get the `jwt` token

- Open chrome browser in [`Developer Tools`](https://developer.chrome.com/devtools) mode
- Login in the [cloud portal](https://dev.portal.tsi.ebi.ac.uk/)
- Find **token** in the `Console` tab of the chrome `Developer Tools`:

```
[AuthService] Persisting token from saml

eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczo [...] U9yKQ
```

and copy it in a `jwt` file.


## Pushing application's parameters

```
curl -H "Authorization: Bearer $(cat jwt)" -H 'Content-Type: application/json' https://api.portal.tsi.ebi.ac.uk/cloudproviderparameters -d "$(cat embassy.txt)"
```

with `embassy.txt`:

```
{"name":"extcloud03", "cloudProvider":"OSTACK", "fields":[{"key":"OS_USERNAME","value":"gianni"}, {"key":"OS_TENANT_NAME", "value":"EBI-TSI"}, {"key":"OS_AUTH_URL","value":"https://extcloud03-keystone.ebi.ac.uk:5000/v2.0"}, {"key":"OS_PASSWORD","value":"your_password"}]}
```

Or also including parameters `chipster embassy`:

```
{"name":"Chipster Embassy", "cloudProvider":"OSTACK", "fields":[{"key":"OS_USERNAME","value":"gianni"}, {"key":"OS_TENANT_NAME", "value":"EBI-TSI"}, {"key":"OS_AUTH_URL","value":"https://extcloud03-keystone.ebi.ac.uk:5000/v2.0"}, {"key":"OS_PASSWORD","value":"your_password"},{"key":"TF_VAR_floatingip_pool","value":"net_external"}, {"key":"TF_VAR_key_name","value":"demo-key"},{"key":"TF_VAR_machine_type","value":"s1.huge"}, {"key":"TF_VAR_disk_image","value":"45938a1d-ade8-4634-bc10-d7096aa4b455"}]}
```

## Stop and Destroy a deployment

- Stop

```
curl -H "Authorization: Bearer  $(cat jwt)" \
'$PORTAL_BASE_URL/deployment/TSI1478180421019/stop' -X PUT
```

- Stop itself

```
curl "$PORTAL_BASE_URL/deployment/TSI1478180421019/stopme" -X PUT \
     -H "Deployment-Secret: $PORTAL_CALLBACK_SECRET"
```

- Destroy

```
curl -H "Authorization: Bearer  $(cat jwt)" \
'$PORTAL_BASE_URL/deployment/TSI1457613148123' -X DELETE
```

`PORTAL_BASE_URL` will be:

* Portal Dev       => https://dev.api.portal.tsi.ebi.ac.uk
* Portal Master    => https://api.portal.tsi.ebi.ac.uk
* Local Deployment => http://localhost:8080

