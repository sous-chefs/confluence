#
# Cookbook Name:: confluence
# Recipe:: configuration
#
# Copyright 2013, Brian Flad
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

settings = merge_confluence_settings

# Fix conf directory permissions (GH-99)
directory File.join(node['confluence']['install_path'], 'conf') do
  owner node['confluence']['user']
  group 'root'
  mode 00755
  action :create
end

template "#{node['confluence']['install_path']}/confluence/WEB-INF/classes/confluence-init.properties" do
  source 'confluence-init.properties.erb'
  owner node['confluence']['user']
  mode '0644'
  notifies :restart, 'service[confluence]', :delayed
end

if settings['database']['type'] == 'mysql'
  mysql_connector_j "#{node['confluence']['install_path']}/confluence/WEB-INF/lib"
end

if node['init_package'] == 'systemd'
  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  template '/etc/systemd/system/confluence.service' do
    source 'confluence.systemd.erb'
    owner 'root'
    group 'root'
    mode 00755
    action :create
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, 'service[confluence]', :delayed
  end
else
  template '/etc/init.d/confluence' do
    source 'confluence.init.erb'
    owner 'root'
    group 'root'
    mode 00755
    action :create
    notifies :restart, 'service[confluence]', :delayed
  end
end

service 'confluence' do
  supports status: true, restart: true
  action :enable
  subscribes :restart, 'java_ark[jdk]'
end
