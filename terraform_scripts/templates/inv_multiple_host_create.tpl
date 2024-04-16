[public]
%{ for ip in public_ip_address ~}
${ip}
%{ endfor ~}
