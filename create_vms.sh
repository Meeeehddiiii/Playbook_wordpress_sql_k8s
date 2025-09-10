#!/bin/bash
set -e

# Variables à personnaliser
RG= »rg-k8s » # Nom du Resource Group
LOC= »francecentral » # Région Azure (ex: westeurope, francecentral)
VNET= »k8s-vnet »
SUBNET= »k8s-subnet »
NSG= »k8s-nsg »
USERNAME= »azureuser »
SSH_KEY= »$HOME/.ssh/id_rsa.pub » # chemin vers ta clé publique

# 1. Créer un Resource Group
az group create -n $RG -l $LOC

# 2. Créer un réseau virtuel + sous-réseau
az network vnet create -g $RG -n $VNET –address-prefix 10.10.0.0/16 \
–subnet-name $SUBNET –subnet-prefix 10.10.1.0/24

# 3. Créer un Network Security Group (NSG)
az network nsg create -g $RG -n $NSG

# 4. Ajouter les règles de sécurité nécessaires
az network nsg rule create -g $RG –nsg-name $NSG -n ssh –priority 1000 \
–access Allow –protocol Tcp –direction Inbound –destination-port-ranges 22
az network nsg rule create -g $RG –nsg-name $NSG -n http –priority 1001 \
–access Allow –protocol Tcp –direction Inbound –destination-port-ranges 80
az network nsg rule create -g $RG –nsg-name $NSG -n nodeport –priority 1002 \
–access Allow –protocol Tcp –direction Inbound –destination-port-ranges 30000-32767

# 5. Créer les VMs (Ubuntu 22.04, taille Standard_B2s)
for i in master worker1 worker2; do
echo « === Création de la VM $i === »
az vm create -g $RG -n $i \
–image Ubuntu2204 \
–size Standard_B2s \
–admin-username $USERNAME \
–ssh-key-values $SSH_KEY \
–vnet-name $VNET \
–subnet $SUBNET \
–nsg $NSG \
–public-ip-sku Basic
done

# 6. Afficher les IP publiques
echo « === IP publiques des VMs === »
az vm list-ip-addresses -g $RG -o table
