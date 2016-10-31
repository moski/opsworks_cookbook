# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Creates the config file wp-config.php with MySQL data.
# - Creates a Cronjob.
# - Imports a database backup if it exists.

# Create the Wordpress config file wp-config.php with corresponding values
node[:deploy].each do |application, deploy|
  Chef::Log.info("Configuring WP app #{application}...")

  if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping WP Configure  application #{application} as it is not defined as php wp")
    next
  end

  deploy = node[:deploy][application]

  #template "#{deploy[:deploy_to]}/current/wp-config.php" do
  template "#{deploy[:deploy_to]}/shared/config/keys.php" do
    source "keys.php.erb"
    mode 0660
    group deploy[:group]
    owner deploy[:user]

    variables(
      :database   => (deploy[:database][:database] rescue nil),
      :user       => (deploy[:database][:username] rescue nil),
      :password   => (deploy[:database][:password] rescue nil),
      :host       => (deploy[:database][:host] rescue nil),
      :keys       => (keys rescue nil),
      :domain     => (deploy[:domains].first))
  end
end
