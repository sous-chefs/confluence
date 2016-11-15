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

    def confluence_database_connection
      settings = merge_confluence_settings

      database_connection = {
        host: settings['database']['host'],
        port: settings['database']['port']
      }

      case settings['database']['type']
      when 'mysql'
        database_connection[:username] = 'root'
        database_connection[:password] = node['mysql']['server_root_password']
      when 'postgresql'
        database_connection[:username] = 'postgres'
        database_connection[:password] = node['postgresql']['password']['postgres']
      end

      database_connection
    end

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
      when 'hsqldb'
        # No-op. HSQLDB doesn't require any configuration.
      else
        raise "Unsupported database type: #{settings['database']['type']}"
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

    # Returns SHA256 checksum of specific Confluence artifact
    def confluence_artifact_checksum
      return node['confluence']['checksum'] unless node['confluence']['checksum'].nil?

      version = node['confluence']['version']
      sums = confluence_checksum_map[version]

      raise "Confluence version #{version} is not supported by the cookbook" unless sums

      case node['confluence']['install_type']
      when 'installer' then sums[confluence_arch]
      when 'standalone' then sums['tar']
      end
    end

    def confluence_arch
      (node['kernel']['machine'] == 'x86_64') ? 'x64' : 'x32'
    end

    # Returns SHA256 checksum map for Confluence artifacts
    def confluence_checksum_map
      {
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
        },
        '5.8.18' => {
          'x32' => 'f57b839822259ed520bbecd4ac5a055556984c5aa67e6a01d22ee3b3de695a6a',
          'x64' => '7424cd7abf210a0e970509d7e7efc00a5fe991ea86cce5b15c0bd0ea4e167f7a',
          'tar' => 'fdd48278913c9990d338b088104f8ddc74d66d5acb3e36c498531b381bfd2382'
        },
        '5.9.1' => {
          'x32' => 'ca092a95744d9ec468e641f492595bc9f99fe5fd809055bc070a426756d484ea',
          'x64' => '5f238aeb4fb5b60ef7525470b011d082ff47c37053eeb758f06e7468fa5e14d7',
          'tar' => '7ec1728d615fd7b4bd8e694fc1fa13db9dd452f293c1948a7fb10d55eec0d1b4'
        },
        '5.9.2' => {
          'x32' => '44c07aff036724ca78bb5173374b4325e8793f0a744451641efe5f9e371bacea',
          'x64' => 'aecda279b3e971e11f3fb9a39b63e7ecca92a178bc82dfb2ae77ddf27d3f4806',
          'tar' => 'd453e636fbcc510ffa66d411c541ac1f4b6f05a32d9c693740f8c3dacf2f2858'
        },
        '5.9.3' => {
          'x32' => 'c928287203ff6ca1f93f0b0338ae42aa1643c8921d9dc5c6dfa202a09dcd31cd',
          'x64' => 'd6c2b1ccadcaff94384fa4459c88a7129fbe91828ee2bd0743bf93646706ed4e',
          'tar' => '8c1fc4daeb891cdf680980ba4f6f3c883b511be4bcb46848d1c27f39735497fe'
        },
        '5.9.4' => {
          'x32' => '29cdf079bf2ce2ab733f44936b7ee9b7e0af4cb015ad9d36767122a0db5219ab',
          'x64' => '55eebdfb228d17fb4ca1b6008a66c3c8dfaed90cf2d4190cff753878de534d70',
          'tar' => '7bfcabd321814c6973bb4a346c4767f810b8bc144a210954047e4af0ad80276a'
        },
        '5.9.5' => {
          'x32' => 'f2f9c27e49d4d469f411b00dbcdb2c46d9ccdc714bf128690090d27f9443201b',
          'x64' => '6b37adc21ea85a8e37a06d88bd3e4d32c25cce2d009f1582066e4c3ff16e61b9',
          'tar' => 'bd4999df5d1bcf9aaee3b3976b10dd3bb44b50c292225b94432aa790ad7d1d13'
        },
        '5.9.9' => {
          'x32' => '108abfe80ee2f854bd7ac6816fa6912784e40b371c4fcc472898a6c90e16e969',
          'x64' => '5d13837cf16d9ca54b542d2ba5b5fc33eae734dd21e214e691490c2bb3149865',
          'tar' => 'e84220e6781949aef1d2e93df5e1dd7d1c793e20099abcf0dff9c04a11686ec4'
        },
        '5.9.10' => {
          'x32' => '11fc44e61625f151b72d16dd541c84b96f910e30f5fc51052737d41c27eb4ac9',
          'x64' => 'c9edc67069ef85e8ec4fefca440dee6c61fb3f33df9d61bcad2a0def8e8d6f09',
          'tar' => '99c468a765c0ba2a0fb535d87e017ccfdd5be78067370f8b34adc58acccd5bd2'
        },
        '5.10.1' => {
          'x32' => '26164f4a8a10869224b4e9ed27969d1ce42a8c1c02b29ccfc4f6a102b494521f',
          'x64' => '839e095b812d496c14edc34ae7206fe502c8d995e468ec1339fe786881bbde20',
          'tar' => 'a3198bf90748b995795c429b625618f978831e81bbf0f14e41f138f324e36bca'
        },
        '5.10.2' => {
          'x32' => '5b9e1f47309b7cd710fc11d9b6fb477822990f934fab7a0681bf1cc5218f7552',
          'x64' => 'd1bf1d675e47021846c3394b6cf46ac434716b40264ec5526637f7a98430a1ad',
          'tar' => 'ab8a527ad54b3dfd8868635ed944183310b46957a922b809921f01429613fb38'
        },
        '5.10.3' => {
          'x32' => '05555962520e0434c2fa9bf986541cabb54a044e01bb58341728c2c8726aa965',
          'x64' => '2b643c561a65b160f823c58259323ae2a04ae18fff104c9ee1bd1c90b1a69f70',
          'tar' => '6e48857c85cdc011e75d52e4d23fa32e9c053051f132d642b284e050fd5735ab'
        },
        '5.10.4' => {
          'x32' => '682cacaaf1d4a267f2bbb7464a36d25a4bf3cf0fd16793794af7d042598030cc',
          'x64' => 'fab39b703d3fcb21621d64449a5f4997a89dd1463ad084bdec191b3105bb70e1',
          'tar' => '4a080e3c9940240154f6a35a013a353e4f8ea00cc6992dad07097a29320d631f'
        },
        '5.10.5' => {
          'x32' => '865c96df292c0fd3b7412607e09a394a03d92494d9bf107beba5f7419e112324',
          'x64' => 'c5d561ff30297f4709dd5ba0a4db1477a5f00589bfdd54df390d7176fef93b79',
          'tar' => '4775e3d089d3592d7fd6cd8c66ee614899cd264a7a6d0179a8c6b1c47d386c35'
        },
        '5.10.6' => {
          'x32' => 'ca73758c248b9cce3648637fbb231528b1003589a0a7aea4375d18ff080844d1',
          'x64' => 'eaf1f336122b0126b9f40a0d5729f33a53a262738105cb1464ed75f27b577590',
          'tar' => '5a4f5ee4aec59836d681f5df868f424540cdd8a3016b5555fe055468a1c0bece'
        },
        '5.10.7' => {
          'x32' => '79d65757fb8eeb32bc54c2bd4edad6bcb5e8b3c6cf167164123732a4046ba0ce',
          'x64' => 'e54d8d5c0541ef04560f8290c7b78cda086d383fbbea24901ff96e5a583d6ab6',
          'tar' => '2b309b7e17f64766e61e991e81a9de59976adb3ad544f3637e125b74f455f3ff'
        },
        '5.10.8' => {
          'x32' => 'e15600ccf3512378a88e5bd59304e486bf4c2256d9f1bbbc41f2126f6980812f',
          'x64' => 'badd2963fd7b0dc2deb11eaa257d7c982145fe59f55204b09303e4d09846905e',
          'tar' => '6346bc1ca7b14d6a131270c88574cdf4f3091543e3a30054fb02c47448058088'
        },
        '6.0.1' => {
          'x32' => 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          'x64' => 'aff42d8bcc61ce7358109fe774f8b46c6713f37c362779639bb64326ac126260',
          'tar' => '444d9aa26d459ab41e42852799ffcb0ad04d1fe7471b52f8275f240860014e95'
        }
      }
    end
  end
end

::Chef::Recipe.send(:include, Confluence::Helpers)
::Chef::Resource.send(:include, Confluence::Helpers)
::Chef::Mixin::Template::TemplateContext.send(:include, Confluence::Helpers)
