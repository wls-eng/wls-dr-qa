%{ for ip in ip_address ~}
Host ${ip}
    HostName ${ip}
    User opc
    port 22
    IdentityFile ${keypath}
%{ endfor ~}
