export AUTH_TOKEN=$(gcloud auth print-access-token)

##set instance name
export INSTANCE_ID=cdf1
export REGION=us-central1

##get CDAP_ENDPOINT
export CDAP_ENDPOINT=$(gcloud beta data-fusion instances describe \
    --location=$REGION \
    --format="value(apiEndpoint)" \
  ${INSTANCE_ID})

echo $CDAP_ENDPOINT

#example to create driver
curl -X POST -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/artifacts/sqlserver" \
-H "Artifact-Plugins: [{ "name": "sqlserver", "type": "jdbc", "className": "com.microsoft.sqlserver.jdbc.SQLServerDriver" }]" \
-H "Artifact-Version: 42" \
--data-binary @./drivers/sqljdbc42.jar

#post compute profile
curl -X PUT -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/profiles/test" -d @./profiles/test-computeprofile.json

#post pipeline
curl -X PUT -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/apps/Test1" -d @./pipelines/Test-cdap-data-pipeline.json