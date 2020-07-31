node.default['confluence']['database']['type'] = 'postgresql'
node.default['postgresql']['version'] = '9.3'
node.default['postgresql']['password']['postgres'] = 'iloverandompasswordsbutthiswilldo'

if platform_family?('debian')
  node.default['postgresql']['enable_pgdg_apt'] = true
  node.default['postgresql']['client']['packages'] = ['postgresql-client-9.3', 'libpq-dev']
  node.default['postgresql']['server']['packages'] = ['postgresql-9.3']
  node.default['postgresql']['contrib']['packages'] = ['postgresql-contrib-9.3']
  node.default['postgresql']['dir'] = '/etc/postgresql/9.3/main'
  node.default['postgresql']['server']['service_name'] = 'postgresql'
elsif platform_family?('rhel')
  node.default['postgresql']['enable_pgdg_yum'] = true
  node.default['postgresql']['client']['packages'] = %w(postgresql93 postgresql93-devel)
  node.default['postgresql']['server']['packages'] = ['postgresql93-server']
  node.default['postgresql']['contrib']['packages'] = ['postgresql93-contrib']
  node.default['postgresql']['server']['service_name'] = 'postgresql-9.3'
  node.default['postgresql']['setup_script'] = 'postgresql93-setup'
end

include_recipe 'confluence'

# required for 'infrataster' gem build (integration tests)
package %w(zlib-devel gcc make patch) if platform_family?('rhel')
