#
# Cookbook:: confluence
# Resource:: config
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

unified_mode true

provides :confluence_config

use '_partial/_common_properties'

property :jvm_minimum_memory, String,
         default: lazy { default_jvm_minimum_memory },
         description: 'JVM minimum heap size (e.g., 256m, 1g)'

property :jvm_maximum_memory, String,
         default: lazy { default_jvm_maximum_memory },
         description: 'JVM maximum heap size (e.g., 1024m, 2g)'

property :jvm_support_recommended_args, String,
         default: '',
         description: 'Additional JVM arguments recommended by Atlassian support'

property :catalina_opts, String,
         default: lazy { default_catalina_opts },
         description: 'Additional CATALINA_OPTS for Tomcat'

property :tomcat_port, String,
         default: lazy { default_tomcat_port },
         description: 'Tomcat HTTP connector port'

property :tomcat_shutdown_port, String,
         default: lazy { default_tomcat_shutdown_port },
         description: 'Tomcat shutdown port'

property :tomcat_max_threads, String,
         default: lazy { default_tomcat_max_threads },
         description: 'Maximum number of request processing threads'

property :tomcat_accept_count, String,
         default: lazy { default_tomcat_accept_count },
         description: 'Maximum queue length for incoming connections'

property :tomcat_proxy_name, [String, nil],
         default: lazy { default_tomcat_proxy_name },
         description: 'Proxy server name (for reverse proxy setups)'

property :tomcat_proxy_port, [String, nil],
         default: lazy { default_tomcat_proxy_port },
         description: 'Proxy server port (for reverse proxy setups)'

property :tomcat_scheme, String,
         equal_to: %w(http https),
         default: lazy { default_tomcat_scheme },
         description: 'URL scheme (http or https)'

property :tomcat_secure, [true, false],
         default: false,
         description: 'Whether the connector is secure'

property :template_cookbook, String,
         default: 'confluence',
         description: 'Cookbook to source templates from'

action :create do
  # Configure confluence-init.properties to point to home directory
  template ::File.join(new_resource.install_path, 'confluence/WEB-INF/classes/confluence-init.properties') do
    source 'confluence-init.properties.erb'
    cookbook new_resource.template_cookbook
    owner 'root'
    group new_resource.group
    mode '0640'
    variables(
      home_path: new_resource.home_path
    )
  end

  # Configure setenv.sh for JVM settings
  template ::File.join(new_resource.install_path, 'bin/setenv.sh') do
    source 'setenv.sh.erb'
    cookbook new_resource.template_cookbook
    owner 'root'
    group new_resource.group
    mode '0750'
    variables(
      home_path: new_resource.home_path,
      jvm_minimum_memory: new_resource.jvm_minimum_memory,
      jvm_maximum_memory: new_resource.jvm_maximum_memory,
      jvm_support_recommended_args: new_resource.jvm_support_recommended_args,
      catalina_opts: new_resource.catalina_opts
    )
  end

  # Configure server.xml for Tomcat
  template ::File.join(new_resource.install_path, 'conf/server.xml') do
    source 'server.xml.erb'
    cookbook new_resource.template_cookbook
    owner 'root'
    group new_resource.group
    mode '0640'
    variables(
      tomcat_port: new_resource.tomcat_port,
      tomcat_shutdown_port: new_resource.tomcat_shutdown_port,
      tomcat_max_threads: new_resource.tomcat_max_threads,
      tomcat_accept_count: new_resource.tomcat_accept_count,
      tomcat_proxy_name: new_resource.tomcat_proxy_name,
      tomcat_proxy_port: new_resource.tomcat_proxy_port,
      tomcat_scheme: new_resource.tomcat_scheme,
      tomcat_secure: new_resource.tomcat_secure
    )
  end
end

action_class do
  include Confluence::Cookbook::Helpers
end
