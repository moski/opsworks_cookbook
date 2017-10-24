execute "cat /etc/apache2/ssl/#{node[:haproxy][:hostname]}.key <\(echo\) /etc/apache2/ssl/#{node[:haproxy][:hostname]}.crt <\(echo\) /etc/apache2/ssl/#{node[:haproxy][:hostname]}.ca > /etc/apache2/ssl/#{node[:haproxy][:cert]}.pem"
execute "add-apt-repository ppa:vbernat/haproxy-1.7"
execute "apt-get update"
 
package 'haproxy' do
  action :install
end

template "/etc/haproxy/haproxy.cfg" do
      source "haproxy.cfg.erb"
      mode 0660

      variables(
        :cert         => (node[:haproxy][:cert] rescue nil),
        :https_backend_port  => (node[:haproxy][:https_backend_port] rescue nil),
        # Domain
        :redirect_domain           => (node[:haproxy][:hostname]))
      notifies :restart, "service[haproxy]"
end
 
Chef::Log.info("Finished Creating HaProxy cfg...")

template "/etc/default/haproxy" do
      source "haproxy-default.erb"
      mode 0660

      variables(:start => (node[:haproxy][:start] rescue nil))
      notifies :restart, "service[haproxy]"
end


execute "echo 'checking if haproxy is not running - if so start it'" do
  not_if "pgrep haproxy"
  notifies :start, "service[haproxy]"
end
 
service 'haproxy' do
  supports :restart => true, :status => true
  action [:enable, :start]
end

