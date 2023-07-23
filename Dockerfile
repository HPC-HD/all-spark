
ARG SPARK_VERSION=3.4.1

FROM jupyter/all-spark-notebook:spark-${SPARK_VERSION}

ARG SPARK_VERSION

ENV NB_GID=0 

USER root

RUN wget -O /usr/local/bin/coursier https://github.com/coursier/coursier/releases/download/v2.1.4/coursier && \
    chmod +x /usr/local/bin/coursier && \
    wget -O /usr/local/spark/jars/hadoop-aws-3.3.6.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.6/hadoop-aws-3.3.6.jar && \
    wget -O /usr/local/spark/jars/spark-hadoop-cloud_2.12-${SPARK_VERSION}.jar https://repo.maven.apache.org/maven2/org/apache/spark/spark-hadoop-cloud_2.12/${SPARK_VERSION}/spark-hadoop-cloud_2.12-${SPARK_VERSION}.jar && \
    wget -O /usr/local/spark/jars/aws-java-sdk-bundle-1.12.512.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.512/aws-java-sdk-bundle-1.12.512.jar && \
    wget -O /usr/local/spark/jars/wildfly-openssl-2.2.5.Final.jar https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/2.2.5.Final/wildfly-openssl-2.2.5.Final.jar && \
    wget -O /usr/local/spark/jars/mariadb-java-client-3.1.4.jar https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/3.1.4/mariadb-java-client-3.1.4.jar && \
    wget -O - https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz | tar -C /usr/lib --strip-components=3 -xz hadoop-3.3.6/lib/native && \
    mamba install --yes poetry && \
    mamba clean --all -f -y

USER ${NB_UID}

RUN /usr/local/bin/coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_2.12.18:0.14.0-RC12 \
      sh.almond:scala-kernel_2.12.18:0.14.0-RC12 \
      --default=true --sources \
      -o /home/jovyan/almond && \
    /home/jovyan/almond --install --force --log info --metabrowse --id scala_2.12 --display-name "Scala 2.12" \
      --copy-launcher \
      --arg "java" \
      --arg "--add-opens=java.base/java.lang=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.lang.invoke=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.lang.reflect=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.io=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.net=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.nio=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.util=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.util.concurrent=ALL-UNNAMED" \
      --arg "--add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED" \
      --arg "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED" \
      --arg "--add-opens=java.base/sun.nio.cs=ALL-UNNAMED" \
      --arg "--add-opens=java.base/sun.security.action=ALL-UNNAMED" \
      --arg "--add-opens=java.base/sun.util.calendar=ALL-UNNAMED" \
      --arg "--add-opens=java.security.jgss/sun.security.krb5=ALL-UNNAMED" \
      --arg "-jar" \
      --arg "/home/jovyan/almond" \
      --arg "--log" \
      --arg "info" \
      --arg "--metabrowse" \
      --arg "--id" \
      --arg "scala_2.12" \
      --arg "--display-name" \
      --arg "Scala 2.12" && \
    rm -rf /home/jovyan/almond /home/jovyan/.ivy2

USER root

RUN fix-permissions /home/jovyan /opt/conda && chmod g+rwX /usr/local/spark && chown :0 /usr/local/spark

USER 65536

EXPOSE 7777

EXPOSE 2222

EXPOSE 4040

