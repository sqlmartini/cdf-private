from pyspark.sql import SparkSession
from threading import Thread
from queue import Queue

# Source variables
database = "AdventureWorks2022"
cloudsql_ip = "10.2.0.2:1433"
db_url = f"jdbc:sqlserver://{cloudsql_ip};databaseName={database};encrypt=true;trustServerCertificate=true;"
db_user = "sqlserver"
db_password = "P@ssword@111"

# Sink variables
dataset_name = "adventureworks"
bucket = "s8s_data_and_code_bucket-272300000818"

def read_config(table):

    config_df = (
        spark.read
        .format("bigquery")
        .option("table", table)
        .load()
    )

    config = config_df.collect()
    return config

def load_table(source, target):
    print(f'source: {source}')
    print(f'target: {target}')

    load_df = (
        spark.read
        .format("jdbc")
        .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver")   
        .option("url", db_url)
        .option("dbtable", source)
        .option("user", db_user)
        .option("password", db_password)
        .load()
    )

    load_df.write \
    .format('bigquery') \
    .mode("overwrite") \
    .option("table","{}.{}".format(dataset_name, target)) \
    .option("temporaryGcsBucket", bucket) \
    .save()

def run_tasks(function, q):
    while not q.empty():
        value = q.get()
        function(value[0], value[1])
        q.task_done()    

spark = SparkSession.builder \
  .appName("ETL Testing")\
  .getOrCreate()

config = read_config("adventureworks.elt_config")

q = Queue()
worker_count = 30

for row in config:
    q.put([row["sourceTableName"], row["targetTableName"]])

for i in range(worker_count):
    t=Thread(target=run_tasks, args=(load_table, q))
    t.daemon = True
    t.start()

q.join()