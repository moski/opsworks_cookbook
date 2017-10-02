package "varnish"
Chef::Log.info("Configuring Varnish...")

template "#{node['varnish']['dir']}/#{node['varnish']['vcl_conf']}" do
  source node['varnish']['vcl_source']
  if node['varnish']['vcl_cookbook']
    cookbook node['varnish']['vcl_cookbook']
  end
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[varnish]"
end
Chef::Log.info("Finished Creating VCL...")

template node['varnish']['default'] do
  source "custom-default.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnish]"
end

Chef::Log.info("Finished Varnish Configuring...")


service "varnish" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishlog" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end