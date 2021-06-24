#!/bin/bash
# Automatizando el despliegue de kubernetes (Ansible)
# https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-18-04-es

# Tareas previas de configuración (master.local y worker.local)
ansible-playbook -i hosts -l master:workers 01-initial-conf.yaml

# Instalación del servidor NFS (nfs.local) 02-install-nfs.yaml
ansible-playbook -i hosts -l nfs 02-install-nfs.yaml

# Tareas comunes a realizar en el nodo master y los workers (master.local y worker.local)
ansible-playbook -i hosts -l master:workers 03-common-tasks.yaml

# Configurando kubernetes en el nodo master (master.local)
ansible-playbook -i hosts -l master 04-config-kubernetes.yaml

# Instalando la SDN (master.local)
ansible-playbook -i hosts -l master 05-install-sdn.yaml

# Configurando los workers (worker.local)
ansible-playbook -i hosts -l master:workers 06-config-workers.yaml

# Instalando un ingress controller (master.local)
ansible-playbook -i hosts -l master 07-install-ingress-controler.yaml

# Creamos un usuario no administrador para la gestión del clúster (master.local)
ansible-playbook -i hosts -l master 08-create-no-root-user.yaml
