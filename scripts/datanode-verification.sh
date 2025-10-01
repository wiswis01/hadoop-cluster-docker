#!/bin/bash
echo "=== VÉRIFICATION DATANODES - PARTIE 3 ==="

# 1. Localisation physique des fichiers
echo "1. Recherche physique dans DataNodes:"
find /hadoop/dfs/data/current -name "blk_*" -type f | head -10

# 2. Vérification réplication HDFS
echo "2. Vérification réplication:"
hdfs fsck /exam_projet/etudiants.txt -files -blocks -locations

# 3. Information détaillée du fichier
echo "3. Information du fichier HDFS:"
hdfs dfs -ls /exam_projet/etudiants.txt

# 4. Statut des DataNodes
echo "4. Statut des DataNodes:"
hdfs dfsadmin -report | grep -A 10 "Datanode"

echo "=== VÉRIFICATION DATANODES TERMINÉE ==="
