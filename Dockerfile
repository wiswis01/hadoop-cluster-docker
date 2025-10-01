FROM mzinee/hadoop-cluster:latest

# Configuration Hadoop avancée
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

# Copie des configurations personnalisées
COPY core-site.xml $HADOOP_CONF_DIR/
COPY hdfs-site.xml $HADOOP_CONF_DIR/
COPY mapred-site.xml $HADOOP_CONF_DIR/
COPY yarn-site.xml $HADOOP_CONF_DIR/

# Script d'initialisation
COPY init-hadoop.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-hadoop.sh

EXPOSE 9870 8088 9000 9864 8042

CMD ["/usr/local/bin/init-hadoop.sh"]
