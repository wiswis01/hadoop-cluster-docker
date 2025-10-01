FROM mzinee/hadoop-cluster:latest

# Mise à jour et installation des outils supplémentaires
RUN apt-get update && apt-get install -y \
    vim \
    curl \
    wget \
    net-tools \
    && apt-get clean

# Configuration Hadoop personnalisée
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

# Script de démarrage personnalisé
COPY start-hadoop.sh /usr/local/bin/start-hadoop.sh
RUN chmod +x /usr/local/bin/start-hadoop.sh

# Exposition des ports
EXPOSE 9870 8088 9864 8042 9000

CMD ["/usr/local/bin/start-hadoop.sh"]
