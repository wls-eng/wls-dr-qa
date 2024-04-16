try:
    connect('{{ admin_user }}','{{ admin_password }}','{{ admin_t3_url }}')
    edit()
    startEdit()
    cd("/SecurityConfiguration/{{ domain_name }}")

    if hasattr(cmo,'setRemoteAnonymousRMIIIOPEnabled'):
        cmo.setRemoteAnonymousRMIIIOPEnabled(false)
    else:
        print('no attribute RemoteAnonymousRMIIIOPEnabled defined under Domain SecurityConfiguration')

    if hasattr(cmo,'setRemoteAnonymousRMIT3Enabled'):
        cmo.setRemoteAnonymousRMIT3Enabled(false)
    else:
        print('no attribute RemoteAnonymousRMIIIOPEnabled defined under Domain SecurityConfiguration')

    save()
    activate()
except Exception, e:
    print e
    dumpStack()

exit()
