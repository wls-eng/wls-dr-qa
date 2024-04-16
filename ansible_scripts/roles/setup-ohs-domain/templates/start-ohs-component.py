import os, sys
nmConnect(username='{{ ohs_nm_user }}',password='{{ ohs_nm_pswd }}',domainName='{{ ohs_domain_name }}')
status=nmServerStatus(serverName='{{ ohs_component_name }}',serverType='OHS')
if status != "RUNNING":
  nmStart(serverName='{{ ohs_component_name }}',serverType='OHS')
  nmServerStatus(serverName='{{ ohs_component_name }}',serverType='OHS')
else:
  print 'OHS component {{ ohs_component_name }} is already running'
