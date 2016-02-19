node.set['confluence']['database']['type'] = 'mysql'

node.set['confluence']['database']['version'] = \
  if node['platform'] == 'ubuntu' && node['platform_version'].to_f <= 13.10
    '5.5'
  else
    '5.6'
  end

node.set['mysql']['server_root_password'] = 'iloverandompasswordsbutthiswilldo'

include_recipe 'confluence'

# required for 'infrataster' gem build (integration tests)
package 'zlib-devel' if node['platform_family'] == 'rhel'
