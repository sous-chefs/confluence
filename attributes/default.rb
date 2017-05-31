#
# Cookbook Name:: confluence
# Attributes:: confluence
#
# Copyright 2013, Brian Flad
# Copyright 2017, Parallels International GmbH
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

default['confluence']['home_path'] = '/var/atlassian/application-data/confluence'
default['confluence']['install_path'] = '/opt/atlassian/confluence'
default['confluence']['install_type'] = 'installer'
default['confluence']['user'] = 'confluence'
default['confluence']['version'] = '6.2.0'
default['confluence']['backup_when_update'] = true

# Defaults are automatically selected from version via helper functions
default['confluence']['url'] = nil
default['confluence']['checksum'] = nil

# Data bag where credentials and other sensitive data could be stored (optional)
default['confluence']['data_bag_name'] = 'confluence'
default['confluence']['data_bag_item'] = 'confluence'

default['confluence']['apache2']['access_log'] = ''
default['confluence']['apache2']['error_log'] = ''
default['confluence']['apache2']['port'] = 80

# Defaults are automatically selected from fqdn and hostname via helper functions
default['confluence']['apache2']['template_cookbook'] = 'confluence'
default['confluence']['apache2']['virtual_host_name'] = nil
default['confluence']['apache2']['virtual_host_alias'] = nil

default['confluence']['apache2']['ssl']['access_log'] = ''
default['confluence']['apache2']['ssl']['chain_file'] = ''
default['confluence']['apache2']['ssl']['error_log'] = ''
default['confluence']['apache2']['ssl']['port'] = 443

case node['platform_family']
when 'rhel'
  default['confluence']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
  default['confluence']['apache2']['ssl']['key_file'] = '/etc/pki/tls/private/localhost.key'
else
  default['confluence']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['confluence']['apache2']['ssl']['key_file'] = '/etc/ssl/private/ssl-cert-snakeoil.key'
end

default['confluence']['database']['host'] = '127.0.0.1'
default['confluence']['database']['name'] = 'confluence'
default['confluence']['database']['password'] = 'changeit'
default['confluence']['database']['type'] = 'mysql'
default['confluence']['database']['user'] = 'confluence'

default['confluence']['autotune']['enabled'] = false
default['confluence']['autotune']['type']    = 'mixed'

# If you don't want total system memory to be automatically discovered through
# Ohai, uncomment the following line and set your own value in kB.
# default['confluence']['autotune']['total_memory'] = '1048576kB' # 1024m

default['confluence']['jvm']['bundled_jre'] = true
default['confluence']['jvm']['minimum_memory'] = '256m'
default['confluence']['jvm']['maximum_memory'] = '512m'
default['confluence']['jvm']['java_opts'] = ''

default['confluence']['tomcat']['port'] = '8090'

default['confluence']['crowd_sso']['enabled'] = false
default['confluence']['crowd_sso']['app_name'] = nil
default['confluence']['crowd_sso']['app_password'] = nil
default['confluence']['crowd_sso']['crowd_base_url'] = 'http://crowd.example.com:8095/crowd'
