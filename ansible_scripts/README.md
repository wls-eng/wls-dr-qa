Use the following commands to encrypt the secret passwords for admin_password and nm_password variables.

ansible-vault encrypt_string --encrypt-vault-id default "<password goes here>" --name "admin_password"
ansible-vault encrypt_string --encrypt-vault-id default "<password goes here>" --name "nm_password"

These commands will output the encrypted password for admin_password and nm_password variables. Copy the contents in to secret.yml file
