import os
import sys

connect('{{ admin_user }}','{{ admin_password }}','{{ admin_t3_url }}')
deploy('{{replicationWebAppName}}','{{ work_dir }}/{{replicationWebAppFileName}}',targets='{{cluster_name}}',remote='true', upload='true')
deploy('{{sessionCounterAppName}}','{{ work_dir }}/{{sessionCounterAppFileName}}',targets='{{cluster_name}}',remote='true', upload='true')
startApplication('{{replicationWebAppName}}')
startApplication('{{sessionCounterAppName}}')
disconnect()
exit()
