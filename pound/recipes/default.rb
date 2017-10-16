service "pound" do
  supports :restart => true
  action :nothing
end

execute "openssl x509 -in /etc/apache2/ssl/#{node[:pound][:hostname]}.crt -out /etc/apache2/ssl/#{node[:pound][:cert]}.pem"
execute "openssl rsa -in /etc/apache2/ssl/#{node[:pound][:hostname]}.key >> /etc/apache2/ssl/#{node[:pound][:cert]}.pem"

template "/etc/pound/pound.cfg" do
      source "pound.cfg.erb"
      mode 0660

      variables(
        :cert         => (node[:pound][:cert] rescue nil),
        :https_backend_port  => (node[:pound][:https_backend_port] rescue nil),
        # Domain
        :redirect_domain           => (node[:pound][:hostname]))
      notifies :start, "service[pound]"
end
 
Chef::Log.info("Finished Creating Pound cfg...")

template "/etc/default/pound" do
      source "pound-default.erb"
      mode 0660

      variables(:start => (node[:pound][:start] rescue nil))
      notifies :start, "service[pound]"
end


execute "echo 'checking if Pound is not running - if so start it'" do
  not_if "pgrep pound"
  notifies :start, "service[pound]"
end
 


