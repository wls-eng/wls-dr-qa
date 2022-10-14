import sys
import socket

readTemplate('{{ domain_template }}')
setOption('DomainName','{{ domain_name }}')
setOption('OverwriteDomain', 'true')

print('Enabling Production Mode...');
setOption('ProductionModeEnabled', 'true')

cd('Servers/AdminServer')
set('Name','{{ admin_server_name }}')

set('ListenAddress','{{ admin_host }}')
set('ListenPort', int('{{ admin_port }}'))

# set Admin Security
cd('{{ domain_classpath }}')
cmo.setName('{{ admin_user }}')
cmo.setPassword('{{ admin_password }}')

print('Enabling SSL port...')
cd('/Servers/{{ admin_server_name }}')
ssl=create('{{ admin_server_name }}','SSL')
ssl.setEnabled(True)

Thread.sleep(100)
cd('/Servers/{{ admin_server_name }}/SSL/{{ admin_server_name }}')
cmo.setEnabled(true)
cmo.setListenPort(int('{{ admin_ssl_port }}'))
cmo.setHostnameVerifier(None)
cmo.setHostnameVerificationIgnored(true)

writeDomain('{{ domain_dir }}')
closeTemplate()

readDomain('{{ domain_dir }}')

# Create the node manager reference.
print('creating nodemanager for admin server')
cd('/')
create('{{ nm_machine_name }}','UnixMachine')
cd('/Machines/{{ nm_machine_name }}')
create('{{ nm_machine_name }}','NodeManager')
cd('NodeManager/{{ nm_machine_name }}')
set('ListenAddress','{{ nm_listen_address }}')
set('ListenPort',int('{{ nm_listen_port }}'))

print('disabling secure mode')
cd('/SecurityConfiguration/{{ domain_name }}')
secmode= create('mySecureMode','SecureMode')
cd('SecureMode/mySecureMode')
set('SecureModeEnabled','false')

cd('/SecurityConfiguration/{{ domain_name }}')
set('NodeManagerUsername','{{ nm_user }}')
set('NodeManagerPasswordEncrypted','{{ nm_password }}')

updateDomain()
closeDomain()

# Exiting
print('Admin Domain Creation Complete ...')

exit()
