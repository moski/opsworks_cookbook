node[:deploy].each do |application, deploy|
 Chef::Log.info("Configuring Pound #{application}...")
 deploy = node[:deploy][application]
  
  execute "openssl x509 -in #{deploy[:hostname]}.crt -out /etc/apache2/ssl/pound.pem"
  execute "openssl rsa -in #{deploy[:hostname]}.key >> /etc/apache2/ssl/pound.pem"
  template "/etc/pound/pound.cfg" do
      source "pound.cfg.erb"
      mode 0660

      variables(
        :cert         => (node[:pound][:cert] rescue nil),
        :https_backend_port  => (node[:pound][:https_backend_port] rescue nil),
        # Domain
        :redirect_domain           => (deploy[:hostname]))
  end

  template "/etc/default/pound" do
      source "pound-default.erb"
      mode 0660

      variables(:start => (node[:pound][:start] rescue nil))
  end
end