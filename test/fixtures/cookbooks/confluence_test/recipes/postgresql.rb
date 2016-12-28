node.normal['confluence']['database']['type'] = 'postgresql'
node.normal['postgresql']['version'] = '9.3'
node.normal['postgresql']['password']['postgres'] = 'iloverandompasswordsbutthiswilldo'

if node['platform'] == 'ubuntu'
  node.normal['postgresql']['enable_pgdg_apt'] = true
  node.normal['postgresql']['client']['packages'] = ['postgresql-client-9.3', 'libpq-dev']
  node.normal['postgresql']['server']['packages'] = ['postgresql-9.3']
  node.normal['postgresql']['contrib']['packages'] = ['postgresql-contrib-9.3']
  node.normal['postgresql']['dir'] = '/etc/postgresql/9.3/main'
  node.normal['postgresql']['server']['service_name'] = 'postgresql'
elsif node['platform'] == 'centos'
  node.normal['postgresql']['enable_pgdg_yum'] = true
  node.normal['postgresql']['client']['packages'] = ['postgresql93', 'postgresql93-devel']
  node.normal['postgresql']['server']['packages'] = ['postgresql93-server']
  node.normal['postgresql']['contrib']['packages'] = ['postgresql93-contrib']
  node.normal['postgresql']['server']['service_name'] = 'postgresql-9.3'
  node.normal['postgresql']['setup_script'] = 'postgresql93-setup'
end

include_recipe 'confluence'

# required for 'infrataster' gem build (integration tests)
package %w(zlib-devel gcc make patch) if node['platform_family'] == 'rhel'
