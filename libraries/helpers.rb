#
# Cookbook Name:: confluence
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
  # Confluence::Helpers module
  module Helpers
    # Detects current Confluence version.
    # Returns nil if Confluence isn't installed.
    #
    # @return [String] Confluence version
    def confluence_version
      pom_file = File.join(
        node['confluence']['install_path'],
        '/confluence/META-INF/maven/com.atlassian.confluence/confluence-webapp/pom.properties'
      )

      begin
        return Regexp.last_match(1) if File.read(pom_file) =~ /^version=(.*)$/
      rescue Errno::ENOENT
        # Confluence is not installed
        return nil
      end
    end

    def confluence_virtual_host_name
      node['confluence']['apache2']['virtual_host_name'] || node['fqdn'] || node['machinename'] || node['hostname']
    end

    def confluence_virtual_host_alias
      node['confluence']['apache2']['virtual_host_alias'] || node['hostname']
    end

    # rubocop:disable Metrics/AbcSize
    def confluence_database_connection
      settings = merge_confluence_settings

      database_connection = {
        :host => settings['database']['host'],
        :port => settings['database']['port']
      }

      case settings['database']['type']
      when 'mysql'
        database_connection.merge!(:username => 'root', :password => node['mysql']['server_root_password'])
      when 'postgresql'
        database_connection.merge!(:username => 'postgres', :password => node['postgresql']['password']['postgres'])
      end

      database_connection
    end
    # rubocop:enable Metrics/AbcSize

    # Merges Confluence settings from data bag and node attributes.
    # Data dag settings always has a higher priority.
    #
    # @return [Hash] Settings hash
    def merge_confluence_settings
      @settings_from_data_bag ||= settings_from_data_bag
      settings = Chef::Mixin::DeepMerge.deep_merge(
        @settings_from_data_bag,
        node['confluence'].to_hash
      )

      case settings['database']['type']
      when 'mysql'
        settings['database']['port'] ||= 3306
      when 'postgresql'
        settings['database']['port'] ||= 5432
      else
        fail "Unsupported database type: #{settings['database']['type']}"
      end

      settings
    end

    # Fetchs Confluence settings from the data bag
    #
    # @return [Hash] Settings hash
    def settings_from_data_bag
      begin
        item = data_bag_item(node['confluence']['data_bag_name'],
                             node['confluence']['data_bag_item'])['confluence']
        return item if item.is_a?(Hash)
      rescue
        Chef::Log.info('No confluence data bag found')
      end
      {}
    end

    # Returns download URL for Confluence artifact
    def confluence_artifact_url
      return node['confluence']['url'] unless node['confluence']['url'].nil?

      version = node['confluence']['version']

      case node['confluence']['install_type']
      when 'installer'
        "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-#{version}-#{confluence_arch}.bin"
      when 'standalone'
        "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-#{version}.tar.gz"
      end
    end

    # rubocop:disable Metrics/AbcSize
    # Returns SHA256 checksum of specific Confluence artifact
    def confluence_artifact_checksum
      return node['confluence']['checksum'] unless node['confluence']['checksum'].nil?

      version = node['confluence']['version']
      sums = confluence_checksum_map[version]

      fail "Confluence version #{version} is not supported by the cookbook" unless sums

      case node['confluence']['install_type']
      when 'installer' then sums[confluence_arch]
      when 'standalone' then sums['tar']
      end
    end
    # rubocop:enable Metrics/AbcSize

    def confluence_arch
      (node['kernel']['machine'] == 'x86_64') ? 'x64' : 'x32'
    end

    # rubocop:disable Metrics/MethodLength
    # Returns SHA256 checksum map for Confluence artifacts
    def confluence_checksum_map
      {
        '4.3.7' => {
          'x32' => '6612ab99ae0cf3ab240f9d9413a25bfe84b3f729cbb12ee4bee4e11a424513d0',
          'x64' => '03bb665b6abdc96495fca3f12683083d5e4633152f0c5cb4464779dcdd869f71',
          'tar' => '18602095e4119cc5498ac14b4b5588e55f707cca73b36345b95c9a9e4c25c34d'
        },
        '5.0.1' => {
          'x32' => 'b856b67564dade5930cae9590fd29ae15326e99e4b548a69b9e336d7e9659881',
          'x64' => '97f233a3d8f0cbedcdbdf10ce7a38cf72c091945a8281909e871828165b6ab8e',
          'tar' => '18a497bf0899835d304e9a33431f347a28312e219d4555302e6332a3145b8191'
        },
        '5.1' => {
          'x32' => '8b6acd4e807964b2c9f3fc9ced0c464183ee8ec73ddc3c8015dadb799be53c4c',
          'x64' => 'ac2cd3842b625ff6d451cf699c3b67685628cea2fd71dfbbcddcabd74f6f25eb',
          'tar' => '3e6eced828d196bb6f18becb524c0191d4561308d71d85178fef84d5a6386203'
        },
        '5.1.1' => {
          'x32' => 'b77472844109da1a9b081d10191c77d6b6c0a50ea8ddc5ce1ddcb36a6320d14e',
          'x64' => '31bb76f8ed517c9828ada1f4a6d9b32db8eec8eb1a0ac9bf2474a861824a813f',
          'tar' => 'deb50f6dbc65b648fca9a7402d6e4ee60b0e779bbd4f1f33bc7b8344dead629e'
        },
        '5.1.2' => {
          'x32' => 'e4a7cd7545087796a12b91c577ef815ddace40f96d042d3027f22cf83ce1cace',
          'x64' => 'fc3b59471bf4ff95c4cae95e254b166c4d44b78d9d5464feb74361da7d00991c',
          'tar' => '291289c3ba7c2c59f3bcf36ca9962e022bc62946f7bdddf382529ae74242bfe2'
        },
        '5.1.3' => {
          'x32' => 'd2f674befaa4935c553616999efa6966e9ec0455f41026187ba50c38e05beb36',
          'x64' => '68ca52ad18a354ac721f38832088420591ebf4b7392b0e405194d7ebdc5b0e3f',
          'tar' => 'e400dadebe14a956d086dcb36deae2e6e12e0204ec9af49c176d62054c167903'
        },
        '5.1.4' => {
          'x32' => '3262bb80a1e7a6df3c66b5dbbd5e26b7d3ab5941a6fb904f4ed890651933aa36',
          'x64' => '5e055daf9a29c055b400df2d99aad8420433accd54a95b5c1067682ac393f25a',
          'tar' => 'e615b1105c5a8a6cd16481d0e4467bd393b0a2065504a04975c5216cfd72d524'
        },
        '5.1.5' => {
          'x32' => '3183183be7b5f0e0c5ea9af9dd562d0964abfa47d46e4720349c5b3e9339f80c',
          'x64' => 'df477559705b72891385b38defa54032e1593bcf5271b3612fbcfbda86aac98e',
          'tar' => '6dfbbc3404d8f96f203b01997fa7211cbf9eee491252d9f1cc5b2e84eb97f1ab'
        },
        '5.2.3' => {
          'x32' => '09387b29824c507cc97fb662ff8b80dcf912c617b12420eed7b5cab3d0fa137f',
          'x64' => '5c518d54bcd06792a5eb7c62cbc031515c242fd944a0c6be64964b6d7f163bdc',
          'tar' => '83b50558fa0f7c514b56ca56e73dbb337e725e1936b4cf2dd9c8a44b43a5e25e'
        },
        '5.2.5' => {
          'x32' => 'd5efce4aaf0dccaaccdac2aeb35c2a7b025770bf05da2e84a4c89ad4de5c7b54',
          'x64' => 'c194abbc53142614adbdb0e3b6cc4a8a1106053563a02ab51a7c87189f502c1d',
          'tar' => '98fef6163e0190d673b5ea4a3a2c8c3dd32e02d729361450515df2c4d5245892'
        },
        '5.3' => {
          'x32' => '5676b8fb7c8bbd1699f6cc5a8bcd7b72973bb98940bd0a56e13e5f96a6532c3d',
          'x64' => '4c61f3511ae3faeab11a689f26fbb82a7fc7c30525bd40c50e8854bc22b8e0be',
          'tar' => 'acc2f3c484bd1855b8c7c9d741da19d51a7595eed78d147d38c2c9aa63627f67'
        },
        '5.4.3' => {
          'x32' => '960b3a2091948ff17e6a42a2c270445a69ed47b63fc8d2e9c460022e04718b8e',
          'x64' => '40ec3b23d1c47dae0b2b39ae32129208ef631940e43d9ae13d3da341e2f1c9c8',
          'tar' => '51b74ff3cd22a26226ea6fa1da13833624263afc18601719f5f5f545b4b100ca'
        },
        '5.4.4' => {
          'x32' => '80008170cfcf9dcc6b61dfb14a0baa948134439e45f8ed784e3858eba3dda802',
          'x64' => 'e82fc4197894ba53f9cbcab1d0158a01727e1def1d348932843375ad2994da0b',
          'tar' => '51c6ee75e3f6109960856700a4e3adfa4d6dc8ce63b6dbeac95a8f22f0ae66e9'
        },
        '5.5.2' => {
          'x32' => '4e2ceb32cfa45085b184bbe08c7d4fbce6985487f9d12855e7fd4d0e60d9c78f',
          'x64' => '6b0361e2e25161f5e2d99380b397b5768fef835922dcb21ae34dfbc484bc203c',
          'tar' => '667190e9006de123e55ccc04e639321070dc65a40658ba3aa0b9d8e3473048eb'
        },
        '5.5.3' => {
          'x32' => '7e4be644b4fb9b58e5794029f0c733cc8537b3e1a8dd797949a8133c7d87ce73',
          'x64' => '0f091ecac293332f0841d80374090c5688fd413272e557d426d0b6809601030b',
          'tar' => '66538cba1a7925c82a2db5d438af27167c0a12dc02466d045a2f006f0f24d524'
        },
        '5.6' => {
          'x32' => '7e3fc60e576e1a8109bb6eceb57797c0391ad81e1e025b75f19ed836846b49e2',
          'x64' => '284a1afc2c6e22414766e7e140fed9821c81ed59cf32995ead2b4c4ecc9fa09f',
          'tar' => 'a3738ea9da8012d7e93180732632d4bf782501cb25fccee960fccc6955117d68'
        },
        '5.6.1' => {
          'x32' => 'a0936d961c95f0c3c4e4c2f6721a46a632d03ffbfefb75f3d225689b3df76744',
          'x64' => '410c09200a7e81ba08e9ca27000140654e8ef1742b873456d3938ec6275aa161',
          'tar' => 'f8ff7ecdc742560ffeab4595200db26b3d1cb1bd0be9a93e418ae06fd6436e1c'
        },
        '5.6.3' => {
          'x32' => '7d252e8d9c092f56737a45d75b6c3643e30ce800e185981828e8419965001bb9',
          'x64' => '7c9545d67dbafa4507603d9e5014ee8ba8975e057dff66edbf40acb85b92c6f8',
          'tar' => '63242c4df873f68461bcf071cf69a98fea07ec58a1e707ad5a5524cec77dcfdd'
        },
        '5.6.5' => {
          'x32' => '068e606b897e769209761c5b8097e9edf358b927109df4c4c58185e565ac2614',
          'x64' => '76e882b9466068cbc3079870e97842d7823a88bc6b6a6e8cb934b6b4ad08872d',
          'tar' => '013b9fc8d20f5947637abefea1386532bb484134de57a70f7fd78d177352bd4d'
        },
        '5.7' => {
          'x32' => 'cb149a15d5052e17955042b6feaca55fabc3a76aa8b0afd19457c415fbed4540',
          'x64' => '3248c326a779007f9753cc1870330e2a09b8f2355466519d76ae3415b582ed52',
          'tar' => '2638d3c33585043168f6f22d7a05e09fde331d8a41080a600cd0f59c88b6ab0d'
        },
        '5.7.1' => {
          'x32' => '6c700207c0c2436f0bacf029a10f633e6d1980a60c7097773c56feec4df0b48b',
          'x64' => '6144b112913d3114caaac93f5ee43191d22980ca704f3b53ef7725dff306d1ee',
          'tar' => '17eae4db5f08e7829f465aa6a98d7bcfe30d335afc97c52f57472c91bbe88da8'
        },
        '5.7.5' => {
          'x32' => '4c885c191ede1e245f2dc92657666fb4101b69429fe45852938afc0fbb1e8168',
          'x64' => 'ff71914f70237270680a14e4b0d7f9aa0b19df28f0738d7c4acd01eb1d5ecb16',
          'tar' => '6bd53451c7cd2cdbf27596d03dce87cc88133f2d3080101ca0f85ba629390c49'
        },
        '5.8.5' => {
          'x32' => 'aae6f2b955225c7e31d6d2ce392d0c4c5f778fa62e4ceb43b22dab8c46344ee1',
          'x64' => '9d8128257593a032c5882bdf08e009d0bdce8a924601d367ac966b9e43c209cf',
          'tar' => '5def693857255bd9e890ab2b621b80aa188c37f0a48dd1b44ef73b7d9d852e2a'
        },
        '5.8.8' => {
          'x32' => 'c447a6f915607ce257c4375d15750810cae9dd2c6bfd22fefb724478f930e2c0',
          'x64' => '8c813671b17bbae0c0e74c8e23e39bb6db9b9171207bff2adcecb6115abdef40',
          'tar' => '9459e357c8090588b06ab23f01954567f7167061731d4eada76b9bdf27d91ca6'
        },
        '5.8.13' => {
          'x32' => 'e09a5e23b507b02192c6446aee9f778f2051719bc7d56152dc52801b63616752',
          'x64' => '62cb049b7fc0e32214de441bf7a0982fd3fd6d2be370582c54467dcfd1e7fdf3',
          'tar' => 'a5c1d31bc652ea0316eab3c52a1840ecbe9161ed1fd55fc63fa1f9cc1a03f112'
        },
        '5.8.16' => {
          'x32' => '1928d9481199286d2ec9c8f29ca172609aac7b2d8a11d905585c11687d32940c',
          'x64' => 'a9cc7bbd99150767722ae9489b2f0905fe8ad69c9aa6d45d9350aa93fabd7f1b',
          'tar' => '9ccf96838a7b00439b62f4a3f1377cd32a83b3169f5e4ee7bd6c8a244b1ea59b'
        },
        '5.8.17' => {
          'x32' => 'c5927999c5e8408c3438a91823a082162f440eb2a095a63db6785515772735d5',
          'x64' => '51f65cfc9b94d4ead3bfe2e5cbe601bab2f97583875a46a3259714fea9ed1a3b',
          'tar' => '5bb9c02cc38e86ad95aeacd85cedb7464a7e18d3a67b4b9798ba9b0425dea1d8'
        }
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end

::Chef::Recipe.send(:include, Confluence::Helpers)
::Chef::Resource.send(:include, Confluence::Helpers)
::Chef::Mixin::Template::TemplateContext.send(:include, Confluence::Helpers)
