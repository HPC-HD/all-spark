FROM bitnami/spark:3.3.0
ADD https://repo1.maven.org/maven2/org/apache/spark/spark-hadoop-cloud_2.12/3.3.0/spark-hadoop-cloud_2.12-3.3.0.jar /opt/bitnami/spark/jars/
USER 0
RUN chown 1001:0 /opt/bitnami/spark/jars/spark-hadoop-cloud_2.12-3.3.0.jar && chmod u=rw,g=rw,o=r /opt/bitnami/spark/jars/spark-hadoop-cloud_2.12-3.3.0.jar
USER 1001
