node[:deploy].each do |application, deploy|
	Chef::Log.info("Creating upload directory for #{application}...")

	if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'
	    Chef::Log.info("Skipping Uploading Assests to S3 Bucket  application #{application} as it is not defined as #{deploy[:application_type]}")
	    next
    end
    tmp = deploy

	deploy = node[:deploy][application]

    Chef::Log.info("Start on creating upload directory")
	directory "#{deploy[:deploy_to]}/current/wp-content/uploads" do
	    mode 0775
	    recursive true
	    group deploy[:group]
	    owner deploy[:user]
	    action :create
	end
    Chef::Log.info("End on creating upload directory")

end

 
