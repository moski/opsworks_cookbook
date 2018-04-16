#react app sync to server

 
node[:deploy].each do |application, deploy|
	Chef::Log.info("Sync React App to local folder from S3 Bucket #{application}...")

	if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'
	    Chef::Log.info("Skipping Sync React App from S3 Bucket  application #{application} as it is not defined as #{deploy[:application_type]}")
	    next
    end
    tmp = deploy

	deploy = node[:deploy][application]

    aws_key = (deploy[:signup_app][:s3_access_key] rescue nil)
	aws_secret = (deploy[:signup_app][:s3_secret_key] rescue nil)
	s3_region = (deploy[:signup_app][:s3_region] rescue nil)
	bucket_name = (deploy[:signup_app][:s3_bucket] rescue nil)
	local_dir = (deploy[:signup_app][:local_dir] rescue nil)

	directory "#{deploy[:deploy_to]}/current/#{local_dir}" do
	    mode 0775
	    recursive true
	    group deploy[:group]
	    owner deploy[:user]
	    action :create
	end
	 
	
	 

 	Chef::Log.info("Start on sync #{local_dir} from #{bucket_name}")
 	
 	execute "export AWS_DEFAULT_REGION=#{s3_region} &&
	         export AWS_ACCESS_KEY_ID=#{aws_key} &&
	         export AWS_SECRET_ACCESS_KEY=#{aws_secret} &&
	         cd #{deploy[:deploy_to]}/current/#{local_dir} &&
			 aws s3 sync s3://#{bucket_name}/ . --recursive"

	Chef::Log.info("End sync /#{local_dir} from #{bucket_name}")

end

 
