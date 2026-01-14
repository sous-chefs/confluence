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

action :create do
  systemd_unit "#{new_resource.service_name}.service" do
    content({
      'Unit' => {
        'Description' => 'Atlassian Confluence',
        'After' => 'network.target',
      },
      'Service' => {
        'Type' => 'forking',
        'User' => new_resource.user,
        'Group' => new_resource.group,
        'Environment' => "CONFLUENCE_HOME=#{new_resource.home_path}",
        'PIDFile' => "#{new_resource.install_path}/work/catalina.pid",
        'ExecStart' => "#{new_resource.install_path}/bin/start-confluence.sh",
        'ExecStop' => "#{new_resource.install_path}/bin/stop-confluence.sh",
        'TimeoutStartSec' => 300,
        'TimeoutStopSec' => 60,
      },
      'Install' => {
        'WantedBy' => 'multi-user.target',
      },
    })
    action :create
  end
end

action :start do
  systemd_unit "#{new_resource.service_name}.service" do
    action :start
  end
end

action :stop do
  systemd_unit "#{new_resource.service_name}.service" do
    action :stop
  end
end

action :restart do
  systemd_unit "#{new_resource.service_name}.service" do
    action :restart
  end
end

action :enable do
  systemd_unit "#{new_resource.service_name}.service" do
    action :enable
  end
end

action :disable do
  systemd_unit "#{new_resource.service_name}.service" do
    action :disable
  end
end

action_class do
  include Confluence::Cookbook::Helpers
end
