#upload dir to s3

=begin
node[:deploy].each do |application, deploy|
	Chef::Log.info("Uploading Assests to S3 Bucket #{application}...")

	if defined?(deploy[:application_type]) && deploy[:application_type] != 'php'
	    Chef::Log.info("Skipping Uploading Assests to S3 Bucket  application #{application} as it is not defined as #{deploy[:application_type]}")
	    next
    end
    tmp = deploy

	deploy = node[:deploy][application]
    
	directory "#{deploy[:deploy_to]}/current/wp-content/uploads" do
	    mode 0775
	    recursive true
	    group deploy[:group]
	    owner deploy[:user]
	    action :create
	end
	 
	aws_key = (deploy[:aws][:s3_access_key] rescue nil)
	aws_secret = (deploy[:aws][:s3_secret_key] rescue nil)
	bucket_name = (deploy[:aws][:s3_bucket] rescue nil)
	s3_region = (deploy[:aws][:s3_region] rescue nil)
	s3_assets_dir = (deploy[:aws][:s3_assets_dir] rescue nil)
	s3_assets_remote = (deploy[:aws][:s3_assets_remote] rescue nil)

 	Chef::Log.info("Start on sync #{s3_assets_dir} to #{bucket_name}")
 	
	execute "export AWS_DEFAULT_REGION=#{s3_region} &&
	 export AWS_ACCESS_KEY_ID=#{aws_key} && cd #{deploy[:deploy_to]}/current/#{s3_assets_dir} && 
	 export AWS_SECRET_ACCESS_KEY=#{aws_secret} &&
	  aws s3 sync . s3://#{bucket_name}/#{s3_assets_remote} --acl public-read --cache-control \"max-age=31536000\" --exclude \"*\" --include \"*.jpg\" --include \"*.png\" --include \"*.css\" --include \"*.js\" --include \"*.gif\" --include \"*.mp4\" --include \"*.webm\" --include \"*.ogv\" --include \"*.ttf\" --include \"*.woff\" --include \"*.woff2\" --include \"*.svg\" --include \"*.eot\""

	execute "export AWS_DEFAULT_REGION=#{s3_region} &&
	 export AWS_ACCESS_KEY_ID=#{aws_key} && 
	 export AWS_SECRET_ACCESS_KEY=#{aws_secret} &&
	 cd #{deploy[:deploy_to]}/current/#{s3_assets_dir} && 
	 echo $(date)::$(git log --format=%B -n 1) >min.task &&
	 aws s3 cp min.task s3://#{bucket_name}/#{s3_assets_remote}"
	 Chef::Log.info("End sync #{s3_assets_remote} to #{bucket_name}")

end

=end
