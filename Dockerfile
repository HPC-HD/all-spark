FROM jupyter/all-spark-notebook

ENV NB_GID=0 

USER root

RUN wget -O /usr/local/bin/coursier https://github.com/coursier/coursier/releases/download/v2.1.0-RC2/coursier && \
    chmod +x /usr/local/bin/coursier

USER ${NB_UID}

RUN /usr/local/bin/coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_2.12.17:0.13.2 \
      sh.almond:scala-kernel_2.12.17:0.13.2 \
      --default=true --sources \
      -o /home/jovyan/almond && \
      /home/jovyan/almond --install --force --log info --metabrowse --id scala_2.12 --display-name "Scala 2.12" \
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
      --arg "/home/jovyan/.local/share/jupyter/kernels/scala_2.12/launcher.jar" \
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

