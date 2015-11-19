node.set['confluence']['database']['type'] = 'postgresql'
node.set['postgresql']['version'] = '9.3'
node.set['postgresql']['password']['postgres'] = 'iloverandompasswordsbutthiswilldo'

# For old platform versions PostgreSQL 9.3 is available in PGDG repos only
if node['platform'] == 'ubuntu' && node['platform_version'].to_f <= 13.10
  node.set['postgresql']['enable_pgdg_apt'] = true
elsif node['platform'] == 'centos' && node['platform_version'].to_f < 7.0
  node.set['postgresql']['enable_pgdg_yum'] = true
end

include_recipe 'confluence'

# required for 'infrataster' gem build (integration tests)
package %w(zlib-devel gcc make patch) if node['platform_family'] == 'rhel'
