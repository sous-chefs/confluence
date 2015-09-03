#
# Cookbook Name:: confluence
# Attributes:: confluence
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

default['confluence']['home_path']      = '/var/atlassian/application-data/confluence'
default['confluence']['install_path']   = '/opt/atlassian/confluence'
default['confluence']['install_type']   = 'installer'
default['confluence']['user']           = 'confluence'
default['confluence']['version']        = '5.8.8'

if node['kernel']['machine'] == 'x86_64'
  default['confluence']['arch'] = 'x64'
else
  default['confluence']['arch'] = 'x32'
end

default['confluence']['apache2']['access_log']         = ''
default['confluence']['apache2']['error_log']          = ''
default['confluence']['apache2']['port']               = 80
default['confluence']['apache2']['virtual_host_name']  = node['fqdn']
default['confluence']['apache2']['virtual_host_alias'] = node['hostname']

default['confluence']['apache2']['ssl']['access_log']       = ''
default['confluence']['apache2']['ssl']['chain_file']       = ''
default['confluence']['apache2']['ssl']['error_log']        = ''
default['confluence']['apache2']['ssl']['port']             = 443

case node['platform_family']
when 'rhel'
  default['confluence']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
  default['confluence']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'
else
  default['confluence']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['confluence']['apache2']['ssl']['key_file']         = '/etc/ssl/private/ssl-cert-snakeoil.key'
end

default['confluence']['database']['host']     = '127.0.0.1'
default['confluence']['database']['name']     = 'confluence'
default['confluence']['database']['password'] = 'changeit'
default['confluence']['database']['type']     = 'mysql'
default['confluence']['database']['user']     = 'confluence'

default['confluence']['jvm']['minimum_memory']  = '256m'
default['confluence']['jvm']['maximum_memory']  = '512m'
default['confluence']['jvm']['maximum_permgen'] = '256m'
default['confluence']['jvm']['java_opts']       = ''

default['confluence']['tomcat']['keyAlias']     = 'tomcat'
default['confluence']['tomcat']['keystoreFile'] = "#{node['confluence']['home_path']}/.keystore"
default['confluence']['tomcat']['keystorePass'] = 'changeit'
default['confluence']['tomcat']['port']         = '8090'
default['confluence']['tomcat']['ssl_port']     = '8443'
