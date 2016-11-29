#upload dir to s3

node[:deploy].each do |application, deploy|
	Chef::Log.info("Uploading Assests to S3 Bucket #{application}...")
	deploy = node[:deploy][application]
    

	workdir = deploy[:aws][:workdir]
	aws_key = deploy[:aws][:s3_access_key]
	aws_secret = deploy[:aws][:s3_secret_key]
	bucket_name = deploy[:aws][:s3_bucket]

	template "/usr/local/bin/aws" do
	  source "aws"
	  mode 0700
	  group deploy[:group]
	  owner deploy[:user]
	end

 	 
	Dir.glob(workdir) do |item|
	  next if item == '.' or item == '..'
	  # do work on real items
	  execute "cd #{workdir} && 
	  EC2_ACCESS_KEY=#{aws_key} EC2_SECRET_KEY=#{aws_secret} /usr/local/bin/aws put #{bucket_name}/wp-content/temp #{item}"
	 
	end
	 
end

