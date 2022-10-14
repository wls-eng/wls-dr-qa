nmConnect('{{ nm_user }}', '{{ nm_password }}', '{{ nm_listen_address }}', '{{ nm_listen_port }}', '{{ domain_name }}');

nmStart('{{ admin_server_name }}');

nmDisconnect();
