import os
import sys

connect('{{ admin_user }}','{{ admin_password }}','{{ admin_t3_url }}')
deploy('{{deployAppName}}','{{ work_dir }}/{{deployAppFileName}}',targets='{{cluster_name}}',remote='true', upload='true')
startApplication('{{deployAppName}}')
disconnect()
exit()
