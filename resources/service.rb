#
# Cookbook:: confluence
# Resource:: service
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

provides :confluence_service

use '_partial/_common_properties'

property :service_name, String,
         default: lazy { confluence_service_name },
         description: 'Name of the systemd service'

property :template_cookbook, String,
         default: 'confluence',
         description: 'Cookbook to source templates from'

action :create do
  # Create systemd service unit
  template ::File.join(systemd_unit_path, "#{new_resource.service_name}.service") do
    source 'confluence.service.erb'
    cookbook new_resource.template_cookbook
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      user: new_resource.user,
      group: new_resource.group,
      install_path: new_resource.install_path,
      home_path: new_resource.home_path
    )
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
  end

  execute 'systemctl-daemon-reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end
end

action :start do
  service new_resource.service_name do
    action :start
  end
end

action :stop do
  service new_resource.service_name do
    action :stop
  end
end

action :restart do
  service new_resource.service_name do
    action :restart
  end
end

action :enable do
  service new_resource.service_name do
    action :enable
  end
end

action :disable do
  service new_resource.service_name do
    action :disable
  end
end

action_class do
  include Confluence::Cookbook::Helpers
end
