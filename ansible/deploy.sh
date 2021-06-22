#!/bin/bash
# Automatizando el despliegue de kubernetes (Ansible)
# https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-18-04-es
# 
# añadir tantas líneas como sean necesarias para el correcto despligue
# ansible-playbook -i hosts -l XXXX playbook
# 01-preview-tasks.yaml
# 02-install-nfs.yaml
# 03-common-tasks.yaml
# 04-config-kubernetes.yaml
# 05-install-sdn.yaml
# 06-config-workers.yaml
# 07-ingress-controler-deploy.yaml
# 08-create-no-root-user

# Tareas previas de configuración (master.local y worker.local) 01-configuration-tasks.yaml
ansible-playbook -i hosts -l master:workers 01-initial-conf.yaml

# Instalación del servidor NFS (master.local) 02-install-nfs.yaml
ansible-playbook -i hosts -l master:nfs 02-install-nfs.yaml

# Tareas comunes a realizar en el nodo master y los workers (master.local y worker.local) 03-common-tasks.yaml
ansible-playbook -i hosts -l master:workers 03-common-tasks.yaml

# Configurando kubernetes en el nodo master (master.local) 04-config-kubernetes.yaml
ansible-playbook -i hosts -l master 04-config-kubernetes.yaml

# Instalando la SDN (master.local) 05-install-sdn.yaml
ansible-playbook -i hosts -l master:workers 05-install-sdn.yaml

# Configurando los workers (worker.local) 06-config-workers.yaml
ansible-playbook -i hosts -l master:workers 06-config-workers.yaml

# Desplegando un ingress controller (master.local) 07-deploy-ingress-controler.yaml
ansible-playbook -i hosts -l master 07-deploy-ingress-controler.yaml

# Creamos un usuario no administrador para la gestión del clúster:
ansible-playbook -i hosts -l master:workers 08-create-no-root-user.yaml
