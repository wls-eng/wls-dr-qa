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

print('disabling secure mode')
cd('/SecurityConfiguration/{{ domain_name }}')
secmode= create('mySecureMode','SecureMode')
cd('SecureMode/mySecureMode')
set('SecureModeEnabled','false')

updateDomain()
closeDomain()

readDomain('{{ domain_dir }}')

cd('/')
create('{{ cluster_name }}','Cluster')
Thread.sleep(100)
cd('/Clusters/{{ cluster_name }}')
cmo.setClusterMessagingMode('unicast')
cmo.setClusterBroadcastChannel('')
cmo.setClusterAddress("")

{% for machine_index in range(1,(number_of_machines+1)|int) %}
machineName{{ machine_index }}='machine{{ machine_index }}'
cd('/')
create(machineName{{ machine_index }},'UnixMachine')
cd('/Machines/'+machineName{{ machine_index }})
create(machineName{{ machine_index }},'NodeManager')
cd('NodeManager/'+machineName{{ machine_index }})
cmo.setNodeManagerHome('{{ nm_home }}')
cmo.setListenPort(int('{{ nm_listen_port }}'))
cmo.setListenAddress("{{ hostvars[groups[lookup('ansible.builtin.vars', '{{ machine_name_prefix }}'+machine_index|string+'_vm')][0]]['internal_ip'] }}")

cd('/')
cd('SecurityConfiguration/{{ domain_name}}')
set('NodeManagerUsername','{{ nm_user}}')
encrypted_password=encrypt('{{ nm_password}}','{{ domain_dir }}')
set('NodeManagerPasswordEncrypted',encrypted_password)

{% endfor %}

updateDomain()
closeDomain()

readDomain('{{ domain_dir }}')


{% for server_index in range(1,(number_of_managed_servers+1)|int) %}

managedServer{{ server_index }}='{{ managed_server_prefix }}{{ server_index }}'
cd('/')
create(managedServer{{ server_index }},'Server')
Thread.sleep(100)
cd('/Servers/' + managedServer{{ server_index }})
set("ListenAddress","{{ hostvars[groups[lookup('ansible.builtin.vars', '{{ managed_server_prefix }}'+server_index|string+'_vm')][0]]['internal_ip'] }}")
set("ListenPort",{{ lookup('ansible.builtin.vars', '{{ managed_server_prefix }}'+server_index|string+'_port')|int }})
set('Machine',"{{ lookup('ansible.builtin.vars', '{{ managed_server_prefix }}'+server_index|string+'_machine') }}")
assign('Server', managedServer{{ server_index }}, 'Cluster', '{{ cluster_name }}')

print('Enabling SSL port... for '+managedServer{{ server_index }})
ssl=create(managedServer{{ server_index }},'SSL')
Thread.sleep(100)
ssl.setEnabled(True)
cd('/Servers/'+managedServer{{ server_index }}+'/SSL/'+managedServer{{ server_index }})
cmo.setEnabled(true)
cmo.setListenPort({{ lookup('ansible.builtin.vars', '{{ managed_server_prefix }}'+server_index|string+'_ssl_port')|int }})
cmo.setHostnameVerifier(None)
cmo.setHostnameVerificationIgnored(true)
cmo.setTwoWaySSLEnabled(false)
cmo.setClientCertificateEnforced(false)
cmo.setJSSEEnabled(true)

{% endfor %}

updateDomain()
closeDomain()

# Exiting
print('Admin Domain Creation Complete ...')

exit()
