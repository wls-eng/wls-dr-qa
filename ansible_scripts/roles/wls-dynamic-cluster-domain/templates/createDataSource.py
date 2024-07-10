# Import the required modules
from java.util import Properties
from java.io import FileInputStream

# Read the properties from the file
adminURL = '{{admin_t3_url}}'
adminUserName = '{{admin_user}}'
adminPassword = '{{admin_password}}'
dataSourceName = '{{datasource_name}}'
jndiName = '{{datasource_jndiName}}'
url = '{{datasource_url}}'
driverClass = '{{datasource_driverClass}}'
walletPath = '{{db_wallet_dir}}'

# Connect to the Admin Server
connect(adminUserName, adminPassword, adminURL)

# Start an edit session
edit()
startEdit()

# Create a new JDBC Data Source
cd('/')
cmo.createJDBCSystemResource(dataSourceName)

cd('/JDBCSystemResources/' + dataSourceName + '/JDBCResource/' + dataSourceName)
cmo.setName(dataSourceName)
cmo.setLeasingEnabled(true)

cd('/JDBCSystemResources/' + dataSourceName + '/JDBCResource/' + dataSourceName + '/JDBCDataSourceParams/' + dataSourceName)
set('JNDINames', jarray.array([String(jndiName)], String))

cd('/JDBCSystemResources/' + dataSourceName + '/JDBCResource/' + dataSourceName + '/JDBCDriverParams/' + dataSourceName)
cmo.setUrl(url)
cmo.setDriverName(driverClass)
cmo.setPasswordEncrypted('')

cd('/JDBCSystemResources/' + dataSourceName + '/JDBCResource/' + dataSourceName + '/JDBCDriverParams/' + dataSourceName + '/Properties/' + dataSourceName)
cmo.createProperty('oracle.net.wallet_location')

cd('/JDBCSystemResources/' + dataSourceName + '/JDBCResource/' + dataSourceName + '/JDBCDriverParams/' + dataSourceName + '/Properties/' + dataSourceName + '/Properties/oracle.net.wallet_location')
cmo.setValue(walletPath)

cd('/JDBCSystemResources/' + dataSourceName + '/JDBCResource/' + dataSourceName + '/JDBCConnectionPoolParams/' + dataSourceName)
cmo.setTestTableName('SQL SELECT 1 FROM DUAL')

# Configure the cluster for Database Leasing
cd('/Clusters/{{cluster_name}}')
cmo.setMigrationBasis('database')

# Configure the cluster to store HTTP session information in the database
cd('/Servers')
servers = cmo.getServers()
for server in servers:
    serverName = server.getName()
    cd('/Servers/' + serverName + '/WebServer/' + serverName + '/WebServerLog/' + serverName)
    cmo.setJDBCStoreDataSource(sessionJndiName)
    cmo.setPersistentStoreType('replicated')
    cmo.setPersistentStoreDirectory('')

# Save and activate the changes
save()
activate()

# Disconnect from the Admin Server
disconnect()
exit()
