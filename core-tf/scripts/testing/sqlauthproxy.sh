sudo apt-get install wget

wget https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.0.0/cloud-sql-proxy.linux.amd64 \
-O cloud-sql-proxy

chmod +x cloud-sql-proxy

./cloud-sql-proxy --address 0.0.0.0 --port 1433 --private-ip cdf-private-sql1:us-central1:cdf-private-sql1

sqlcmd -S 127.0.0.1 -U sqlserver -C
sqlcmd -S 10.2.0.3 -U sqlserver -C