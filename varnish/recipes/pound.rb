node[:deploy].each do |application, deploy|
 Chef::Log.info("Configuring Pound #{application}...")
 deploy = node[:deploy][application]
  template "/etc/pound/pound.cfg" do
      source "pound.cfg.erb"
      mode 0660

      variables(
        # DB configuration
        :cert         => (node[:pound][:cert] rescue nil),
        :https_backend_port  => (node[:pound][:https_backend_port] rescue nil),
        # Domain
        :domain           => (deploy[:hostname])
  end
end