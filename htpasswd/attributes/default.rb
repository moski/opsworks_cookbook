default['htpasswd']['install_method'] = 'packages' # Can be python or ruby

default['htpasswd']['built-in']['lang'] = 'python'

default['htpasswd']['install_dir'] = '/usr/local/bin'
default['htpasswd']['path']        = ::File.join(node['htpasswd']['install_dir'], 'htpasswd')

default['htpasswd']['packages'] = value_for_platform_family(
  %w(fedora rhel) => ['httpd-tools'],
  %w(debian default suse) => ['apache2-utils']
)
