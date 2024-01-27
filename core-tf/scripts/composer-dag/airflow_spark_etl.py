from pendulum import datetime
import os
from airflow.decorators import dag, task
from airflow.operators import bash_operator
from airflow.providers.google.cloud.operators.dataproc import DataprocDeleteClusterOperator

@dag(
    start_date=datetime(2024, 1, 1), max_active_runs=3, schedule=None, catchup=False, template_searchpath=['/home/airflow/gcs/data']
)
def airflow_spark_etl():

    PROJECT_ID = os.environ['ENV_PROJECT_ID'] 
    REGION = os.environ['ENV_DATAPROC_REGION']
    SUBNET = "dataproc-subnet"
    JOB_FILE = "gs://anthonymm-dataproc-staging/spark_etl_parallel.py"
    JAR_FILE = "gs://anthonymm-dataproc-jars/mssql-jdbc-12.4.0.jre8.jar"

    params_list = { 
        "project_id" : PROJECT_ID,
        "region" : REGION,
        "subnet" : SUBNET,
        "job_file" : JOB_FILE,
        "jar_file" : JAR_FILE
    }

    run_spark = bash_operator.BashOperator(
        task_id="pyspark_task", 
        bash_command='bash_submit_dataproc_job.sh',
        params=params_list,        
    )

    run_spark

airflow_spark_etl()