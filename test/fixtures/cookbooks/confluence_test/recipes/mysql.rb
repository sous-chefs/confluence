node.normal['confluence']['database']['type'] = 'mysql'
node.normal['confluence']['database']['version'] = '5.6'

node.normal['mysql']['server_root_password'] = 'iloverandompasswordsbutthiswilldo'

include_recipe 'confluence'

# required for 'infrataster' gem build (integration tests)
package 'zlib-devel' if node['platform_family'] == 'rhel'
