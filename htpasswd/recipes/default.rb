# Create htpasswd file

node[:deploy]
apache_user = (node[:htpasswd][:user] rescue nil)
apache_password = (node[:htpasswd][:password] rescue nil)
execute "htpasswd -cb /etc/apache2/htpasswd #{apache_user} #{apache_password}"