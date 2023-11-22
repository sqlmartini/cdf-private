# Ingest data with Cloud Data Fusion from Cloud SQL and load to BigQuery

## About the lab

This repo demonstrates the configuration of a data ingestion process that connects a private Cloud Data Fusion instance to a private Cloud SQL instance.

### Prerequisites

- A pre-created project
- You need to have organization admin rights, and project owner privileges or work with privileged users to complete provisioning.

## 1. Clone this repo in Cloud Shell

```
git clone https://github.com/sqlmartini/cdf-cloudsql-private.git
```

## 2. Foundational provisioning automation with Terraform 
The Terraform in this section updates organization policies and enables Google APIs.<br>

1. Configure project you want to deploy to by running the following in Cloud Shell
```
export PROJECT_ID="enter your project id here"

gcloud config set project ${PROJECT_ID}
gcloud auth application-default set-quota-project ${PROJECT_ID}
```

2. Paste this in Cloud Shell
```
cd ~/cdf-cloudsql-private/foundations-tf
```

3. Run the Terraform for organization policy edits and enabling Google APIs
```
terraform init
terraform apply \
  -var="project_id=${PROJECT_ID}" \
  -auto-approve
```

**Note:** Wait till the provisioning completes (~5 minutes) before moving to the next section.

<hr>

## 3. Core resource provisioning automation with Terraform 

### 3.1. Resources provisioned
In this section, we will provision:
1. User Managed Service Account and role grants
2. Network, subnets, firewall rules
3. Private IP allocation for Cloud Data Fusion
4. Data Fusion instance and VPC peering connection
5. BigQuery dataset
6. Cloud SQL instance
7. GCE SQL proxy VM with static private IP

### 3.2. Run the terraform scripts

1. Paste this in Cloud Shell after editing the GCP region variable to match your nearest region-

```
cd ~/cdf-cloudsql-private/core-tf
```

```
PROJECT_NBR=`gcloud projects describe $PROJECT_ID | grep projectNumber | cut -d':' -f2 |  tr -d "'" | xargs`
GCP_ACCOUNT_NAME=`gcloud auth list --filter=status:ACTIVE --format="value(account)"`
GCP_REGION="us-central1"
CDF_NAME="cdf1"
CDF_VERSION="BASIC"
CDF_RELEASE="6.9.2"
```

2. Run the Terraform for provisioning the rest of the environment
```
terraform init
terraform apply \
  -var="project_id=${PROJECT_ID}" \
  -var="project_number=${PROJECT_NBR}" \
  -var="gcp_account_name=${GCP_ACCOUNT_NAME}" \
  -var="gcp_region=${GCP_REGION}" \
  -var="cdf_name=${CDF_NAME} \
  -var="cdf_version=${CDF_VERSION} \
  -var="cdf_release=${CDF_RELEASE} \
  -auto-approve >> dpgce-core-tf.output
```

**Note:** Takes ~20 minutes to complete.


## 4. Download and import Cloud SQL- SQL Server sample database

### 4.1 Download AdventureWorks sample database

cd ~/core-tf/database
curl -LJO https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak

### 4.2 Import sample database to Cloud SQL 

Run the commands in ~/core-tf/scripts/2-cloudsql.sh in Cloud Shell

## 5. Modify CDF compute profile, pipeline, and deploy

### 5.1. Modify compute profile

Open ~/core-tf/profiles/test-computeprofile.json and modify the "serviceAccount" value to the correct project_id

### 5.2. Modify pipeline
Open ~/core-tf/pipelines/Test-cdap-data-pipeline.json and modify the "host" property to the static IP address of the cloud sql proxy VM.  You can obtain this value by running terraform outputs

### 5.3 Deploy
Run the commands in ~/core-tf/scripts/3-datafusion.sh in Cloud Shell

## 6. Run the Cloud Data Fusion pipeline
TO-DO
