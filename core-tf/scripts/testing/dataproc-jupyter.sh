PROJECT_ID="enter your project id here"
REGION="us-central1"
JOB_CLUSTER_NAME="amm-elt-dev"
SUBNET="spark-snet"
SERVICE_ACCOUNT="cdf-lab-sa@$PROJECT_ID.iam.gserviceaccount.com"
JAR_FILE="gs://s8s_data_and_code_bucket-272300000818/drivers/mssql-jdbc-12.4.0.jre8.jar"

gcloud dataproc clusters create $JOB_CLUSTER_NAME \
--enable-component-gateway \
--region $REGION \
--subnet $SUBNET \
--master-machine-type n1-standard-4 \
--master-boot-disk-size 500 \
--num-workers 2 \
--worker-machine-type n2-standard-4 \
--worker-boot-disk-size 500 \
--properties spark:spark.jars=$JAR_FILE,\
dataproc:dataproc.conscrypt.provider.enable=false \
--initialization-actions "gs://goog-dataproc-initialization-actions-us-central1/connectors/connectors.sh" \
--metadata spark-bigquery-connector-version=0.34.0 \
--optional-components JUPYTER \
--service-account $SERVICE_ACCOUNT \
--project $PROJECT_ID