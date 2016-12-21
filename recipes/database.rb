#
# Cookbook Name:: confluence
# Recipe:: database
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

case settings['database']['type']
when 'mysql'
  mysql2_chef_gem 'confluence' do
    client_version settings['database']['version'] if settings['database']['version']
    action :install
  end

  mysql_service 'confluence' do
    version settings['database']['version'] if settings['database']['version']
    bind_address settings['database']['host']
    port settings['database']['port'].to_s
    data_dir node['mysql']['data_dir'] if node['mysql']['data_dir']
    initial_root_password node['mysql']['server_root_password']
    action [:create, :start]
  end

  mysql_database settings['database']['name'] do
    connection confluence_database_connection
    collation 'utf8_bin'
    encoding 'utf8'
    action :create
  end

  # See this MySQL bug: http://bugs.mysql.com/bug.php?id=31061
  mysql_database_user '' do
    connection confluence_database_connection
    host 'localhost'
    action :drop
  end

  mysql_database_user settings['database']['user'] do
    connection confluence_database_connection
    host '%'
    password settings['database']['password']
    database_name settings['database']['name']
    action [:create, :grant]
  end

when 'postgresql'
  include_recipe 'postgresql::server'
  include_recipe 'database::postgresql'

  postgresql_database_user settings['database']['user'] do
    connection confluence_database_connection
    password settings['database']['password']
    action :create
  end

  postgresql_database settings['database']['name'] do
    connection confluence_database_connection
    connection_limit '-1'
    # See: https://confluence.atlassian.com/display/JIRAKB/Health+Check%3A+Database+Collation
    encoding 'utf8'
    collation 'C'
    template 'template0'
    owner settings['database']['user']
    action :create
  end

when 'hsqldb'
  # No-op. HSQLDB doesn't require any configuration.
  Chef::Log.warn('HSQLDB should not be used in production')
end
