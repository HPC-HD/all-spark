# Rahti Spark Cluster

Instructions for setting up a Spark Cluster for the TextReuse ETL pipeline on CSC Rahti

## Steps


1. Create a project on CSC Rahti
2. Add a `spark-credentials` secret with
   - **username** for Spark
   - **password** for Spark and Jupyter Lab login
   - **nbpassword**  for the Jupyter internally
3. Install OpenShift CLI and Helm on local machine 
4. Create a `values.yaml` following the [`values-template.yaml`](./all-spark/values-template.yaml) 
5. Log into OpenShift project by getting login command from Rahti
6. Run `helm install spark-cluster all-spark`