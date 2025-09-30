# =============================================================================
# Hadoop Single-Node Cluster on Debian
# A minimal Docker image for running Hadoop in pseudo-distributed mode
# =============================================================================

# Start with a slim Debian base to keep the image small
FROM debian:12-slim

# =============================================================================
# Environment Configuration
# =============================================================================

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Hadoop version we want to install
ARG HADOOP_VERSION=3.3.6

# Set up Java and Hadoop environment paths
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin:$PATH

# =============================================================================
# System Dependencies Installation
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Basic networking and download tools
    curl ca-certificates \
    # SSH for Hadoop node communication
    openssh-server openssh-client \
    # System utilities
    sudo procps net-tools \
    # Java runtime (Hadoop dependency)
    openjdk-11-jdk \
    # Lightweight init system for proper signal handling
    tini \
    # Privilege escalation tool (like su, but better)
    gosu \
    # Text editors for convenience
    vim nano \
    # Clean up package lists to reduce image size
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# =============================================================================
# Hadoop Installation
# =============================================================================
RUN mkdir -p /opt && \
    # Download Hadoop from Apache mirror
    echo "Downloading Hadoop version ${HADOOP_VERSION}..." && \
    curl -fsSL https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o /tmp/hadoop.tgz && \
    # Extract and install to /opt/hadoop
    tar -xzf /tmp/hadoop.tgz -C /opt && \
    mv /opt/hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
    # Clean up the downloaded archive
    rm /tmp/hadoop.tgz && \
    echo "Hadoop ${HADOOP_VERSION} installed successfully"

# =============================================================================
# User and Security Setup
# =============================================================================
RUN groupadd -g 1000 hadoop && \
    useradd -m -u 1000 -g hadoop -s /bin/bash hadoop && \
    # Allow hadoop user to run sudo commands without password
    echo "hadoop ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/hadoop && \
    chmod 0440 /etc/sudoers.d/hadoop && \
    echo "Created 'hadoop' user for running services"

# =============================================================================
# SSH Configuration for Hadoop
# =============================================================================
RUN ssh-keygen -A && \
    mkdir -p /home/hadoop/.ssh && \
    chown -R hadoop:hadoop /home/hadoop/.ssh && \
    chmod 700 /home/hadoop/.ssh

# =============================================================================
# Hadoop Configuration Files
# =============================================================================
# Copy custom configuration files for pseudo-distributed mode
COPY core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml $HADOOP_CONF_DIR/

# =============================================================================
# Entrypoint Script and Permissions
# =============================================================================
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && \
    chown -R hadoop:hadoop $HADOOP_HOME && \
    echo "Entrypoint script configured"

# =============================================================================
# HDFS Directory Setup
# =============================================================================
RUN mkdir -p /hdfs/namenode /hdfs/datanode && \
    chown -R hadoop:hadoop /hdfs && \
    echo "HDFS directories created: /hdfs/namenode, /hdfs/datanode"

# =============================================================================
# Container Runtime Configuration
# =============================================================================
# Switch to non-root user for security
USER hadoop

# Set working directory to user's home
WORKDIR /home/hadoop

# Use tini as init system to handle signals properly
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]

# Default command (can be overridden)
CMD ["bash"]
