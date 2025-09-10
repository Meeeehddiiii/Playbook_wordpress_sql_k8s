# Playbook_wordpress_sql_k8s
Cahier des charges — Projet 2

Automatisation de la mise en production de WordPress via Ansible et Kubernetes
Agenda
Déployer WordPress et MySQL sur Kubernetes, en utilisant des volumes persistants fournis
par un serveur NFS, et assurer la résilience de l’application.
Description

L’organisation a besoin d’une plateforme WordPress fonctionnelle appuyée sur une base
MySQL.

· WordPress doit être déployé avec un service NodePort pour être accessible depuis
l’extérieur.
· MySQL doit être déployé avec un volume persistant hébergé sur un serveur NFS.
· Les données sensibles sont stockées dans des Secrets Kubernetes, les données non
sensibles dans des ConfigMaps.
· L’ensemble de l’environnement est limité à un namespace spécifique (wp-project1).
Outils nécessaires
· Ansible (déploiement automatisé et orchestration)
· Kubernetes (kubeadm, kubelet, kubectl)
· Container runtime (containerd)
· NFS (serveur + clients)
· ETCD (sauvegarde du cluster)


Prérequis:
· Un cluster Kubernetes à 3 nœuds (1 master, 2 workers) installé via kubeadm.
· Accès SSH aux nœuds via Ansible.
· Un serveur NFS configuré sur le cluster.


Objectifs du projet:
· Installer Ansible et préparer l’automatisation.
· Déployer un cluster Kubernetes de 3 nœuds.
· Mettre en place une application multi-tiers WordPress + MySQL.
· Déployer un service réseau adéquat (NodePort) pour l’accès externe.
· Protéger les données sensibles avec des Secrets et les non-sensibles avec des
ConfigMaps.
· Effectuer des sauvegardes du cluster Kubernetes avec etcdctl.
· Vérifier la disponibilité de l’application et tester son accès externe.
· Assurer la persistance des données grâce à NFS (volumes pour MySQL et WordPress).
Contraintes techniques
· Les pods WordPress et MySQL doivent utiliser le serveur NFS pour stocker leurs
données.
· WordPress doit attendre que le service MySQL soit disponible pour démarrer.
· L’application doit être accessible depuis Internet via le NodePort exposé.
· Toutes les ressources doivent être isolées dans le namespace wp-project1.


Démarche réalisée:
1. Installation d’Ansible.
2. Installation et configuration d’un cluster Kubernetes de 3 nœuds (1 master, 2 workers).
3. Déploiement initial de pods/tests pour vérifier le cluster.
4. Création et vérification des services (MySQL en ClusterIP, WordPress en NodePort).
5. Mise en place du serveur NFS et configuration des volumes persistants.
6. Configuration du client NFS sur les nœuds Kubernetes.
7. Création et vérification des PersistentVolumes (PV) et PersistentVolumeClaims
(PVC).
8. Création d’un Secret Kubernetes pour stocker les credentials MySQL.
9. Création d’une ConfigMap pour stocker la configuration non sensible de WordPress.
10. Sauvegarde de la base de données Kubernetes ETCD avec etcdctl snapshot save.
11. Vérification complète du fonctionnement de l’application :
· Pods en état Running
· Résolution DNS interne fonctionnelle
· Connexion DB WordPress → MySQL OK
· HTTP accessible depuis le cluster et depuis l’extérieur (IP publique du worker).


Résultat attendu : WordPress opérationnel et accessible depuis Internet, avec
stockage persistant NFS et sauvegarde ETCD disponible.
