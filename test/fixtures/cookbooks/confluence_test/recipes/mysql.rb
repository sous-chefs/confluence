node.set['confluence']['database']['type'] = 'mysql'
node.set['confluence']['database']['version'] = '5.6'

node.set['mysql']['server_root_password'] = 'iloverandompasswordsbutthiswilldo'

include_recipe 'confluence'

# required for 'infrataster' gem build (integration tests)
package 'zlib-devel' if node['platform_family'] == 'rhel'
