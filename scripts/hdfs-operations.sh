#!/bin/bash
echo "=== EXÉCUTION HDFS - PARTIE 2 ==="

# 1. Création répertoire /exam_projet
echo "1. Création du répertoire /exam_projet"
hdfs dfs -mkdir -p /exam_projet
echo "✅ Répertoire créé"

# 2. Création fichier caché .copie.txt
echo "2. Création fichier caché .copie.txt"
hdfs dfs -touchz /exam_projet/.copie.txt
echo "✅ Fichier caché créé"

# 3. Création fichier etudiants.txt avec noms commençant par A et prénoms par S
echo "3. Création fichier etudiants.txt"
cat > /data/etudiants.txt << EOF
Amara Sidi
Amina Sarr
Abdoul Sylla
Aissatou Samake
Adama Soumare
EOF
echo "✅ Fichier local créé avec 5 noms (A... S...)"

# 4. Copie vers HDFS
echo "4. Copie vers HDFS"
hdfs dfs -put /data/etudiants.txt /exam_projet/
echo "✅ Fichier copié vers HDFS"

# 5. Affichage contenu initial
echo "5. Contenu initial HDFS:"
hdfs dfs -cat /exam_projet/etudiants.txt

# 6. Modification locale
echo "6. Modification locale - ajout d'un nom"
echo "Awa Sangare" >> /data/etudiants.txt
echo "✅ Nouveau nom ajouté localement"

# 7. Mise à jour HDFS
echo "7. Mise à jour HDFS"
hdfs dfs -put -f /data/etudiants.txt /exam_projet/
echo "✅ HDFS mis à jour"

# 8. Affichage contenu final
echo "8. Contenu final HDFS:"
hdfs dfs -cat /exam_projet/etudiants.txt

echo "=== OPÉRATIONS HDFS TERMINÉES ==="
