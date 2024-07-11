# Import the required modules
from java.util import Properties
from java.io import FileInputStream

# Read the properties from the file
adminURL = '{{admin_t3_url}}'
adminUserName = '{{admin_user}}'
adminPassword = '{{admin_password}}'
dataSourceName = '{{datasource_name}}'
jndiName = '{{datasource_jndiName}}'
jdbcUrl = '{{datasource_url}}'
driverClass = '{{datasource_driverClass}}'
walletPath = '{{db_wallet_dir}}'
clusterName= '{{cluster_name}}'
dbUsername='{{db_username}}'
dbPassword='{{db_password}}'

try:

    # Connect to the Admin Server
    connect(adminUserName, adminPassword, adminURL)

    # Start an edit session
    edit()
    startEdit()

    cd('/')
    cmo.createJDBCSystemResource(dataSourceName)

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName)
    cmo.setName(dataSourceName)

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName+'/JDBCDataSourceParams/'+dataSourceName)
    set('JNDINames',jarray.array([String(jndiName)], String))

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName)
    cmo.setDatasourceType('GENERIC')

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName+'/JDBCDriverParams/'+dataSourceName)
    cmo.setUrl(jdbcUrl)
    cmo.setDriverName(driverClass)
    cmo.setPassword(dbPassword)

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName+'/JDBCConnectionPoolParams/'+dataSourceName)
    cmo.setTestTableName('SQL ISVALID\r\n\r\n')

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName+'/JDBCDriverParams/'+dataSourceName+'/Properties/'+dataSourceName)
    cmo.createProperty('user')

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName+'/JDBCDriverParams/'+dataSourceName+'/Properties/'+dataSourceName+'/Properties/user')
    cmo.setValue(dbUsername)

    cd('/JDBCSystemResources/'+dataSourceName+'/JDBCResource/'+dataSourceName+'/JDBCDataSourceParams/'+dataSourceName)
    cmo.setGlobalTransactionsProtocol('OnePhaseCommit')

    cd('/JDBCSystemResources/'+dataSourceName)
    set('Targets',jarray.array([ObjectName('com.bea:Name='+clusterName+',Type=Cluster')], ObjectName))

    # Save and activate the changes
    save()
    activate()

except Exception, e:
    print e
    dumpStack()
    undo('true', 'y')
    cancelEdit('y')

# Disconnect from the Admin Server
disconnect()
exit()
