export PLUGIN_PACKAGE_NAME=plugin-multi-table-plugins
export PLUGIN_NAME=multi-table-plugins
export PLUGIN_VERSION=1.4.0
curl -O https://storage.googleapis.com/hub-cdap-io/v2/packages/$PLUGIN_PACKAGE_NAME/$PLUGIN_VERSION/$PLUGIN_NAME-$PLUGIN_VERSION.jar

GET /v3/namespaces/default/artifacts/multi-table-plugins/versions/<artifact-version>/extensions/<plugin-type>/plugins/<plugin-name>[?scope=<scope>&artifactName=<plugin-artifact-name>&artifactVersion=<plugin-version>&artifactScope=<plugin-scope>&limit=<limit>&order=<order>]
GET /v3/namespaces/default/artifacts/multi-table-plugins

GET /v3/namespaces/default/artifacts[?scope=system]

curl GET -H "Authorization: Bearer ${AUTH_TOKEN}" "${CDAP_ENDPOINT}/v3/namespaces/default/artifacts