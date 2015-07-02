#
# Cookbook Name:: confluence
# Library:: confluence
#
# Copyright 2013
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

# Chef class
class Chef
  # Chef::Recipe class
  class Recipe
    # Chef::Recipe::Confluence class
    class Confluence
      def self.settings(node) # rubocop:disable Metrics/AbcSize
        begin
          if Chef::Config[:solo]
            begin
              settings = Chef::DataBagItem.load('confluence', 'confluence')['local']
            rescue
              Chef::Log.info('No confluence data bag found')
            end
          else
            begin
              settings = Chef::EncryptedDataBagItem.load('confluence', 'confluence')[node.chef_environment]
            rescue
              Chef::Log.info('No confluence encrypted data bag found')
            end
          end
        ensure
          settings ||= node['confluence']

          case settings['database']['type']
          when 'mysql'
            settings['database']['port'] ||= 3306
          when 'postgresql'
            settings['database']['port'] ||= 5432
          else
            Chef::Log.warn('Unsupported database type.')
          end
        end

        settings
      end
    end
  end
end
