FROM mzinee/hadoop-cluster:latest

# Métadonnées pour l'examen
LABEL projet="Examen Hadoop Docker"
LABEL version="1.0"
LABEL auteur="wiswis01"

# Configuration Hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root  
ENV YARN_RESOURCEMANAGER_USER root

# Copie des configurations
COPY config/core-site.xml $HADOOP_CONF_DIR/
COPY config/hdfs-site.xml $HADOOP_CONF_DIR/
COPY config/mapred-site.xml $HADOOP_CONF_DIR/
COPY config/yarn-site.xml $HADOOP_CONF_DIR/

# Scripts d'initialisation
COPY scripts/init-hadoop.sh /usr/local/bin/
COPY scripts/hdfs-operations.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

# Ports Hadoop
EXPOSE 9870 8088 9000 9864 8042

CMD ["/usr/local/bin/init-hadoop.sh"]
