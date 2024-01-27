PROJECT_ID="{{ params.project_id }}"
REGION="{{ params.region }}"
JAR_FILE="{{ params.jar_file }}"
JOB_FILE="{{ params.job_file }}"
SUBNET="{{ params.subnet }}"

gcloud dataproc batches submit --project $PROJECT_ID \
    --region $REGION \
    pyspark $JOB_FILE \
    --version 2.1 \
    --jars $JAR_FILE \
    --subnet $SUBNET