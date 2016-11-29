#upload dir to s3

node[:deploy].each do |application, deploy|
	Chef::Log.info("Uploading Assests to S3 Bucket #{application}...")

	if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'
	    Chef::Log.info("Skipping Uploading Assests to S3 Bucket  application #{application} as it is not defined as #{deploy[:application_type]}")
	    next
    end
    tmp = deploy

	deploy = node[:deploy][application]
    

	workdir = (deploy[:aws][:workdir] rescue nil)
	aws_key = (deploy[:aws][:s3_access_key] rescue nil)
	aws_secret = (deploy[:aws][:s3_secret_key] rescue nil)
	bucket_name = (deploy[:aws][:s3_bucket] rescue nil)
	s3_region = (deploy[:aws][:s3_region] rescue nil)
	template "/usr/local/bin/aws" do
	  source "aws"
	  mode 0700
	  group deploy[:group]
	  owner deploy[:user]
	end

 	Chef::Log.info("workdir = #{workdir}...")
 	Chef::Log.info("bucket_name = #{bucket_name}...")
 	#execute "export AWS_ACCESS_KEY_ID=#{s3_access_key}"
 	#execute "export AWS_SECRET_ACCESS_KEY=#{s3_secret_key}"
 	#execute "export AWS_DEFAULT_REGION=#{s3_region}"
	execute "cd #{workdir} && 
	  aws sync .  s3://#{bucket_name}/tmp"
	 
	 
end

