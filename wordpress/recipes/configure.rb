# Create the Wordpress config file wp-config.php with corresponding values
node[:deploy].each do |application, deploy|
  Chef::Log.info("Configuring WP app #{application}...")

  if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'
    Chef::Log.info("Skipping WP Configure  application #{application} as it is not defined as #{deploy[:application_type]}")
    next
  end
  tmp = deploy
  deploy = node[:deploy][application]

  apache = node[:apache]
  apache_user = (apache[:ap_user] rescue nil)
  apache_password = (apache[:ap_password] rescue nil)

  template "#{deploy[:deploy_to]}/shared/config/keys.php" do
    source "keys.php.erb"
    mode 0660
    group deploy[:group]
    owner deploy[:user]

    variables(
      # DB configuration
      :database         => (deploy[:database][:database] rescue nil),
      :user             => (deploy[:database][:username] rescue nil),
      :password         => (deploy[:database][:password] rescue nil),
      :host             => (deploy[:database][:host] rescue nil),

      # authentication
      :auth_key         => (deploy[:authentication][:auth_key] rescue nil),
      :secret_auth_key  => (deploy[:authentication][:secret_auth_key] rescue nil),
      :logged_in_key    => (deploy[:authentication][:logged_in_key] rescue nil),
      :nonce_key        => (deploy[:authentication][:nonce_key] rescue nil),
      :auth_salt        => (deploy[:authentication][:auth_salt] rescue nil),
      :secure_auth_salt => (deploy[:authentication][:secure_auth_salt] rescue nil),
      :logged_in_salt   => (deploy[:authentication][:logged_in_salt] rescue nil),
      :nonce_salt       => (deploy[:authentication][:nonce_salt] rescue nil),

      # S3 secret keys
      :s3_access_key    => (deploy[:aws][:s3_access_key] rescue nil),
      :s3_secret_key    => (deploy[:aws][:s3_secret_key] rescue nil),
      :s3_bucket    => (deploy[:aws][:s3_bucket] rescue nil),
      :s3_region    => (deploy[:aws][:s3_region] rescue nil),
      :cf_id    => (deploy[:aws][:cf_id] rescue nil),

      :wsc_link    => (deploy[:aws][:wsc_link] rescue nil),
      :redis_url    => (deploy[:aws][:redis][:url] rescue nil),
      :redis_client    => (deploy[:aws][:redis][:client] rescue nil),

      # email notifier
      :notifier_url    => (deploy[:notifier][:url] rescue nil),

      # branch io key
      :branchio_key    => (deploy[:branchio][:key] rescue nil),

      # MailChimp
      :mailchimp_key    => (deploy[:mailchimp][:api_key] rescue nil),
      :mailchimp_list_id    => (deploy[:mailchimp][:list_id] rescue nil),

      #Varnish Secret Key
      :varnish_secret_ket    => (deploy[:varnish][:secret_key] rescue nil),

      #google keys
      :google_map_api_key    => (deploy[:google][:map_api_key] rescue nil),
      
      :google_recaptcha_key_v2    => (deploy[:google][:recaptcha_key_v2] rescue nil),
      :google_recaptcha_secret_key_v2    => (deploy[:google][:recaptcha_secret_key_v2] rescue nil),
     
      :google_recaptcha_key_invisible    => (deploy[:google][:recaptcha_key_invisible] rescue nil),
      :google_recaptcha_secret_key_invisible    => (deploy[:google][:recaptcha_secret_key_invisible] rescue nil),

      # Domain
      :domain           => (deploy[:domains].first))
  end

  #template "#{deploy[:deploy_to]}/shared/config/health-check.php" do
    #source "health-check.php.erb"
    #mode 0660
    #group deploy[:group]
    #owner deploy[:user]
    #variables(:domain => (deploy[:domains].first))
  #end

  execute "htpasswd -cb /etc/apache2/.htpasswd #{apache_user} #{apache_password}"
 
end
