import os
import sys

connect('{{ admin_user }}','{{ admin_password }}','{{ admin_t3_url }}')
state('{{ cluster_name }}','Cluster')
start('{{ cluster_name }}','Cluster')
state('{{ cluster_name }}','Cluster')
disconnect()
exit()
