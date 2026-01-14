#
# Cookbook:: confluence
# Library:: helpers
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

module Confluence
  module Cookbook
    module Helpers
      def confluence_arch
        node['kernel']['machine'] == 'x86_64' ? 'x64' : 'x32'
      end

      def confluence_service_name
        'confluence'
      end

      def default_confluence_user
        'confluence'
      end

      def default_confluence_group
        'confluence'
      end

      def default_home_path
        '/var/atlassian/application-data/confluence'
      end

      def default_install_path
        '/opt/atlassian/confluence'
      end

      def default_jvm_minimum_memory
        '256m'
      end

      def default_jvm_maximum_memory
        '1024m'
      end

      def default_catalina_opts
        ''
      end

      def default_tomcat_port
        '8090'
      end

      def default_tomcat_shutdown_port
        '8000'
      end

      def default_tomcat_max_threads
        '150'
      end

      def default_tomcat_accept_count
        '100'
      end

      def default_tomcat_proxy_name
        nil
      end

      def default_tomcat_proxy_port
        nil
      end

      def default_tomcat_scheme
        'http'
      end

      def confluence_download_url(version, install_type)
        base_url = 'https://www.atlassian.com/software/confluence/downloads/binary'

        case install_type.to_s
        when 'installer'
          "#{base_url}/atlassian-confluence-#{version}-#{confluence_arch}.bin"
        when 'standalone'
          "#{base_url}/atlassian-confluence-#{version}.tar.gz"
        else
          raise ArgumentError, "Unknown install_type: #{install_type}. Must be 'installer' or 'standalone'"
        end
      end

      def confluence_installed_version(install_path)
        pom_file = ::File.join(
          install_path,
          'confluence/META-INF/maven/com.atlassian.confluence/confluence-webapp/pom.properties'
        )

        return unless ::File.exist?(pom_file)

        content = ::File.read(pom_file)
        match = content.match(/^version=(.*)$/)
        match ? match[1].strip : nil
      end

      def systemd_unit_path
        '/etc/systemd/system'
      end
    end
  end
end

Chef::DSL::Recipe.include Confluence::Cookbook::Helpers
Chef::Resource.include Confluence::Cookbook::Helpers
