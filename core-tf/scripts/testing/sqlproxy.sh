export PROJECT=cdf-private-sql2
export REGION=us-central1
export ZONE=`gcloud compute zones list --filter="name=${REGION}" --limit 1 --uri --project=${PROJECT}| sed 's/.*\///'`
export NETWORK=vpc-main
export SUBNET=compute-snet
export INSTANCE_NAME=sql-proxy-test
export SQL_CONN="${PROJECT}:${REGION}:${PROJECT}"
export VM_IMAGE=$(gcloud compute images list --project=${PROJECT} | grep cos-stable | awk 'FNR == 1 {print $1}')
export SQL_PORT=1433 # MySQL 3306 # PostgreSQL 5432 # SQLServer 1433

gcloud compute --project=${PROJECT} instances create ${INSTANCE_NAME} \
--zone=${ZONE} \
--machine-type=g1-small \
--subnet=${SUBNET} \
--metadata=startup-script="docker run -d -p 0.0.0.0:${SQL_PORT}:${SQL_PORT} gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy -instances=${SQL_CONN}=tcp:0.0.0.0:${SQL_PORT}" \
--maintenance-policy=MIGRATE \
--scopes=https://www.googleapis.com/auth/cloud-platform \
--image=${VM_IMAGE} \
--image-project=cos-cloud \
--service-account="cdf-lab-sa@${PROJECT}.iam.gserviceaccount.com"
