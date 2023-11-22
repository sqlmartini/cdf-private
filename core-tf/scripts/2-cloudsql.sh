gsutil mb -p $PROJECT_ID -l us-central1 gs://$PROJECT_ID-sql-backups
gsutil cp ~/cdf-cloudsql-private/core-tf/database/AdventureWorks2022.bak gs://$PROJECT_ID-sql-backups
gcloud sql import bak $PROJECT_ID gs://$PROJECT_ID-sql-backups/AdventureWorks2022.bak --database=AdventureWorks2022