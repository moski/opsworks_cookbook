node[:deploy].each do |application, deploy|
 Chef::Log.info("Configuring Pound #{application}...")
 deploy = node[:deploy][application]
  template "/etc/pound/pound.cfg" do
      source "pound.cfg.erb"
      mode 0660

      variables(
        # DB configuration
        :cert         => (deploy[:database][:database] rescue nil),
        :https_backend_port             => (deploy[:database][:username] rescue nil),
        # Domain
        :domain           => (deploy[:domains].first))
  end
end