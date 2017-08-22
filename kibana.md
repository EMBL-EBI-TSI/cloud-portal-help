# TSI Kibana

TSI Kibana endpoint: [https://kibana.tsi.ebi.ac.uk](https://kibana.tsi.ebi.ac.uk)

### How to collect deployment's information

1. Choose a sensible `Time Range` from the upper right menu icon.
2. Type in the search bar:

```
deployment_reference:tsi1502803354196
```

#### Tip:  Convert time-stamps to human readable date

Each portal deployment is identified by a timestamp in milliseconds, following the `TSI` prefix.  
It is simple to convert time stamps human readable date.  
This information can be used to restrict the `time range` of the Kibana's queries.

Bash command:

```
timestamp=tsi1502803354196
date -r ${timestamp:3:10}
```
` Tue 15 Aug 2017 14:22:34 BST`
