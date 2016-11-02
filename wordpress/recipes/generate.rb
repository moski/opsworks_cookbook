node[:deploy].each do |app_name, deploy_config|
  # determine root folder of new app deployment
  app_root = "#{deploy_config[:deploy_to]}/current"

  Chef::Log.info("*********** Deploy Config *************")
  Chef::Log.info(deploy_config)
  Chef::Log.info("********** End Deploy Config **************")
end
