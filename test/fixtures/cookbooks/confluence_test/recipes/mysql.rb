node.default['confluence']['database']['type'] = 'mysql'
node.default['confluence']['database']['version'] = '5.6'

node.default['mysql']['server_root_password'] = 'iloverandompasswordsbutthiswilldo'

include_recipe 'confluence'

# required for 'infrataster' gem build (integration tests)
package 'zlib-devel' if platform_family?('rhel')
