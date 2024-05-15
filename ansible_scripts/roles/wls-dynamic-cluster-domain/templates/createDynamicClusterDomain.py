import sys
import socket

try:

    readTemplate('{{ domain_template }}')
    cd('/Security/base_domain/User/weblogic')
    cmo.setName('{{ admin_user }}')
    cmo.setPassword('{{ admin_password }}')

    cd('Servers/AdminServer')
    set('Name','{{ admin_server_name }}')
    set('ListenAddress','{{ admin_host }}')
    set('ListenPort', int('{{ admin_port }}'))

    setOption('DomainName','{{ domain_name }}')
    setOption('OverwriteDomain', 'true')

    print('Enabling SSL port...')
    cd('/Servers/{{ admin_server_name }}')
    ssl=create('{{ admin_server_name }}','SSL')
    ssl.setEnabled(True)

    Thread.sleep(100)
    cd('/Servers/{{ admin_server_name }}/SSL/{{ admin_server_name }}')
    cmo.setEnabled(true)
    cmo.setListenPort(int('{{ admin_ssl_port }}'))

    writeDomain('{{ domain_dir }}')
    closeTemplate()

    readDomain('{{ domain_dir }}')

    print('Enabling Production Mode...');
    set("ProductionModeEnabled", "true")

    print('disabling secure mode')
    cd('/SecurityConfiguration/{{ domain_name }}')
    secmode= create('mySecureMode','SecureMode')
    cd('SecureMode/mySecureMode')
    set('SecureModeEnabled','{{ secure_mode_enabled }}')

    print('disabling DefaultInternalServlets')
    cd('/Servers/{{ admin_server_name }}')
    set('DefaultInternalServletsDisabled','false')
    set('TunnelingEnabled','true')

    cd('/Servers/{{ admin_server_name }}')
    set('ExternalDNSName','{{ admin_external_ip }}')

    create('{{ admin_server_name }}','ServerStart')
    cd('/Servers/{{ admin_server_name }}/ServerStart/{{ admin_server_name }}')
    arguments = cmo.getArguments()
    if(str(arguments) == 'None'):
       arguments = '{{ server_startup_arguments }}'
    elif ( '{{ server_startup_arguments }}' not in str(arguments)):
       arguments = str(arguments) + ' ' + '{{ server_startup_arguments }}'
    cmo.setArguments(arguments)

    updateDomain()
    closeDomain()

    readDomain('{{ domain_dir }}')

    {% for machine_index in range(1,num_vms_in_wls_domain|int) %}

    machineName{{ machine_index }}='machine{{ machine_index }}'
    cd('/')
    create(machineName{{ machine_index }},'UnixMachine')
    cd('/Machines/'+machineName{{ machine_index }})
    create(machineName{{ machine_index }},'NodeManager')
    cd('NodeManager/'+machineName{{ machine_index }})
    cmo.setNodeManagerHome('{{ nm_home }}')
    cmo.setListenPort(int('{{ nm_listen_port }}'))
    cmo.setListenAddress("{{ hostvars[groups['vm'+(machine_index+1)|string][0]]['ansible_fqdn'] }}")

    {% endfor %}

    cd("/")
    dyncluster=create('{{ cluster_name }}', 'Cluster')

    server_template=create('{{ server_template_name }}', "ServerTemplate")
    server_template.setListenPort({{ ms_port_min }})
    server_template.setCluster(dyncluster)

    cd("/Clusters/{{ cluster_name }}")
    cmo.setMigrationBasis('consensus')
    cmo.setClusterMessagingMode('unicast');

    dynamicServers=create('{{ cluster_name }}', "DynamicServers")
    dynamicServers.setServerTemplate(server_template)
    dynamicServers.setDynamicClusterSize({{ dynamic_cluster_size }})
    dynamicServers.setMaxDynamicClusterSize({{ max_dynamic_cluster_size }})
    dynamicServers.setCalculatedListenPorts(true)
    dynamicServers.setCalculatedMachineNames(true)
    dynamicServers.setServerNamePrefix('{{ managed_server_prefix }}')
    dynamicServers.setMachineNameMatchExpression('{{ machine_name_match_expression }}')

    print('disabling DefaultInternalServlets for servers in dynamic cluster')
    cd('/ServerTemplates/{{ server_template_name }}')
    set('DefaultInternalServletsDisabled','false')

    cd('/ServerTemplates/{{ server_template_name }}')
    cmo.setAdministrationPort({{ local_administration_port_override }})
    cmo.setTunnelingEnabled(true)

    ssl=create('{{ server_template_name }}','SSL')
    ssl.setEnabled(True)
    cd('/ServerTemplates/{{ server_template_name }}/SSL/{{ server_template_name }}')
    cmo.setEnabled(true)
    cmo.setListenPort(int('{{ ms_ssl_port_min }}'))

    cd('/ServerTemplates/{{ server_template_name }}')
    create('{{ server_template_name }}','ServerStart')
    cd('/ServerTemplates/{{ server_template_name }}/ServerStart/{{ server_template_name }}')
    arguments = cmo.getArguments()
    if(str(arguments) == 'None'):
       arguments = '{{ server_startup_arguments }}'
    elif ( '{{ server_startup_arguments }}' not in str(arguments)):
       arguments = str(arguments) + ' ' + '{{ server_startup_arguments }}'
    cmo.setArguments(arguments)

    cd('/')
    cd('SecurityConfiguration/{{ domain_name}}')
    set('NodeManagerUsername','{{ nm_user}}')
    encrypted_password=encrypt('{{ nm_password}}','{{ domain_dir }}')
    set('NodeManagerPasswordEncrypted',encrypted_password)

    updateDomain()
    closeDomain()

    # Exiting
    print('Dynamic Cluster Domain Creation Complete ...')

except Exception, e:
    print e
    dumpStack()

exit()
