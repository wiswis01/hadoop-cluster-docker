#!/bin/bash
echo "🎯 DÉMONSTRATION COMPLÈTE - TOUS LES LIVRABLES"

# 1. Construction image
echo "=== LIVRABLE 1: Construction Docker ==="
docker-compose build

# 2. Démarrage cluster
echo "=== LIVRABLE 5: Déploiement avec Docker Compose ==="
docker-compose up -d

# Attente initialisation
sleep 30

# 3. Exécution opérations HDFS
echo "=== LIVRABLE 2: Opérations HDFS ==="
docker exec namenode /usr/local/bin/hdfs-operations.sh

# 4. Vérification DataNodes
echo "=== LIVRABLE 3: Vérification DataNodes ==="
docker exec datanode1 /usr/local/bin/datanode-verification.sh

# 5. Publication Docker Hub (simulée)
echo "=== LIVRABLE 4: Publication Docker Hub ==="
echo "Commande à exécuter MANUELLEMENT:"
echo "docker tag <votre_username>/hadoop-exam:1.0 <votre_username>/hadoop-exam:1.0"
echo "docker push <votre_username>/hadoop-exam:1.0"

echo "✅ DÉMONSTRATION TERMINÉE - TOUS LES LIVRABLES PRÊTS"
