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
default['confluence']['url_base']       = 'http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence'
default['confluence']['user']           = 'confluence'
default['confluence']['version']        = '5.7'

if node['java'] && node['java']['java_home']
  default['confluence']['jre_home'] = "#{node['java']['java_home']}/jre/"
else
  default['confluence']['jre_home'] = "#{node['confluence']['install_path']}/jre/"
end

if node['kernel']['machine'] == 'x86_64'
  default['confluence']['arch'] = 'x64'
else
  default['confluence']['arch'] = 'x32'
end

# rubocop:disable BlockNesting
case node['platform_family']
when 'windows'
  case node['confluence']['install_type']
  when 'cluster-standalone'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster.zip"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then 'c9f9213a787d76151ef133d75247707300cb55e93c28961276b8c6c4f702b3bf'
      when '5.0.1' then '58cfd477deba06d2d3c87be37a69ac75b9f6b463f011b4586b4ab1b64d2dd3b2'
      when '5.1' then '8177fbb2c9804447b3dcc4157af1c0bb41070fdbe07091c2a7b893a4f3717388'
      when '5.1.1' then 'f89d5f072f142b50e1106b5b68550d04764dedb795e5db3e222fdc7bb0a4c62b'
      when '5.1.2' then '81b4d51be773b23bacbb244e6276a50a43bc6aa759bedfd69be24058d43dde46'
      when '5.1.3' then '0d21727b22c5dfe1b7d130f2a5e5469df7fa3aa8f200d67b4979ff32fc022c37'
      when '5.1.4' then '1eec6f1404228945ee131b080c0755baf4682dcfb1d9c6d4a8ead2645b1d28cb'
      when '5.1.5' then 'dc8e9b7e903850c073071c41dfd01eca55a147a8a6aa94400b62fd3cf0a25de0'
      when '5.2.3' then '7b674bc4936b11c9f8607b9f23a50660e1ca0b3d5422d3ae531fef4438d13301'
      when '5.2.5' then '8abe637f02eb41adbedbae8c17ed798a5465b1ae1d67bb4dd130a9f00a9085c0'
      when '5.3' then '91b82f2351835891c6962ae04b1c7f266186f5620cb42c7a85a344d802e7311a'
      when '5.5.2' then 'becfec2648f820449f36ff765260553026d96d03823e83ff4657d3401b3a05c5'
      when '5.5.3' then '12f7d30d9d587dee7b2be9f17e8c4b5c79818e726f8f85a03de50b719e8e726e'
      when '5.6' then '0146b49a33cdfd300ff5617b53f842e4dbcb0e3f12d0c5a61880ba27b99e04a3'
      when '5.6.1' then 'a7c11a3c33b0c15b1c04d77378e45a00026a0d7e75f811e2d64aacb97c62d003'
      when '5.6.3' then 'efbecce058c0876deefdf3311c7fa3eaa2b82ebafb4fadbaab1a75ae8bc70281'
      when '5.6.5' then '2377691b4801546e0af294d4d8ee0d5283e9f05e72e34d2c4c5181858cf59ec6'
      when '5.7' then '4e3d443275abf1251f2cb2a523e330277128ae86ad01eb3d645d2310d90131d0'
      when '5.7.1' then '0d87136602cb809e4cfa05dec96ac4ff3400beaf95c6a64e528a29ea251c4552'
      end
  when 'cluster-war'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster-war.zip"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then '92176b0f398cc6b2c6fc9def18268bb82e85361ae297de1a4380d10d0b55c4a6'
      when '5.0.1' then '0abaadb03af9b3c5aeb784da7cc98f8e63123995cbd741b63d1a003059efd1f5'
      when '5.1' then '0665ee08310d1f4595b9985c3efbb3c1cbf1b6d6bcf7e62aec970584fd661fef'
      when '5.1.1' then 'ef45984ac7481e05841ccd3bb9e5fedf9505a6eb654f31626dc6cb4b54ce1405'
      when '5.1.2' then 'ce5d2cb968a92ade00937bf4e3eb859d58bcee80fb2b5d1561de456d490fa532'
      when '5.1.3' then '4385f649e122f3997df632e6a485669bde031e07988755daf7602b34a69a7255'
      when '5.1.4' then '2aaa3bc668dbfa27b565fdfe629fd619003bc529890bdb8f1c1c34eb0d4be5ba'
      when '5.1.5' then '9120c01d5cf7d40bfc60a02f573f844ad8dcb0357c3193de0f6c1ec048171b5b'
      when '5.2.3' then 'aeaadfb4ea47fabf8d8fc83bce6e91f0616d0d621af4476cb862a1612a22ae4f'
      when '5.2.5' then '824969b0f9b2806fc67b9ce1d83f737512d44d4ca19d34e6e04736572b2e6368'
      when '5.3' then 'd7762ff2733a9e5b0b0b26b00e10ba3fd79c0b132e31df9c23d1204bd69d6b80'
      when '5.5.2' then 'e4a08685acff77bc08217aa2f827c4e83b868abec73331dc8277b2f1472bb9e1'
      when '5.5.3' then '1010dfb22ea3cbbf7a1c91ac5265d9426595d8dc92b761b1a79cc07cc5a3b838'
      when '5.6' then 'f8e6527bf9b0aa270b44d799c4827671d085bc7958d625ae7d17d9882e1b5f88'
      when '5.6.1' then '22e2405e19e4618013a7fa0d94b77a9afb67e02818dc05ca613fd59b03efc06e'
      when '5.6.3' then 'c9e7f1ea06e562375a91fb161dd2015fc57661748d39f4b278677f77782d481d'
      when '5.6.5' then 'a63694bb7847c135570fc82f8c83c00d7d1fc6e5eaf2e357ea6aa6a68027a3ef'
      when '5.7' then '1c81780d5172812f1b6dea0ce3cd8c4b3ddb0277d19f4b4f629b5dddf10feb50'
      when '5.7.1' then '29f8a38f0d7752852e082f7e9efb19009cd0133f39e2bc08ed246127735c9f17'
      end
  when 'installer'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-#{node['confluence']['arch']}.exe"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then node['confluence']['arch'] == 'x64' ? '5cc58d87f82afae574f053135ee214719c5e46f689affc1bdb819f69c69ed216' : '5316a2a4b35efc0342fee27044ca65f3eff1103ac4f09fb3d11596941dd00b55'
      when '5.0.1' then node['confluence']['arch'] == 'x64' ? 'f2766ee08ffa5a5d6662f150848f4fbc6aba3bc785679f146a4c94dbfcb59f6b' : '31ebe313124b95dd37981cc9d4b76bae25a4029fa33ac0779bc89162f12a2aa3'
      when '5.1' then node['confluence']['arch'] == 'x64' ? '51c0352709fafe435b3812d40c1962f8a8fe90d20521cab6aba75dcb30af6ff5' : '5ec353141e58ca653b061f292e0809d60dac98171e71e12292eb7a349f838066'
      when '5.1.1' then node['confluence']['arch'] == 'x64' ? '200d7e550096758ed405a4f5606b194f0e59ed202a7cb3d7a93e3e94ead6d047' : '3b72f72457bd87e2df086a306df680e97a3f6eb1e2b8551536d54e7de0c8432e'
      when '5.1.2' then node['confluence']['arch'] == 'x64' ? '6832360d34298f8680b849f3d1f68e11483b1f1a05948fd2aa31603bb5f0cb19' : 'e93412658a60c9eeb4749d20f53cec337b4ccabdd0270726c31e725b2c70e94e'
      when '5.1.3' then node['confluence']['arch'] == 'x64' ? '15ceb8421a7238993eaecb7a22cffd705d365d5a3bf57b72432552978695a5a9' : '5c8bd96bd5ab1c7316592ed91e4181551265f588b93c04c6f111206fff9cc912'
      when '5.1.4' then node['confluence']['arch'] == 'x64' ? 'a3663067b0521910e128cd28776eb10fee4694b957a7999be8a9971997643ff6' : '6de497bc8d680fba5258c91ca39fb619f3500a2d8324968a19cb0e83b8a44729'
      when '5.1.5' then node['confluence']['arch'] == 'x64' ? 'be8422e0c18711945e5b9e266fe7432579457d0bf150f251b890839d19e92ed3' : '94d36a8721c6ea2d8f94d4e1e83059789d202e57fa43b23997f3630e6819811d'
      when '5.2.3' then node['confluence']['arch'] == 'x64' ? 'f9a1a39f5ed945c81423209063d04e31259a00323144f2ded1aa2d467ea833a9' : 'ae82a88cc5dabdc85eade09248b3090beaed72481923da57befeb65c5f6c6f91'
      when '5.2.5' then node['confluence']['arch'] == 'x64' ? '475ff07681f091d2870c8374f1d42cd1daf5784e0382635459d1278eb7ea4a38' : '846dcfab2088d8a3b8532291248014bcda513b062f07d0a32e425858f38dbc93'
      when '5.3' then node['confluence']['arch'] == 'x64' ? '8beceacff1224800ff65680c901818285f0fcd3b43f827404a696de0a091437d' : 'a5f60497bb30fb7580062f5e1e1464a0fbd8bacfa86b32e36697ed725d8b7834'
      when '5.5.2' then node['confluence']['arch'] == 'x64' ? '76b7053aced3c859753e83b1109ebb5b00cae30ae87110c7c5d64fa40f7680b3' : '64dcb47341ad5daa28d015f7ce7a9b80eb8d8cc88f948a95e124150f12fa8612'
      when '5.5.3' then node['confluence']['arch'] == 'x64' ? 'e81417234cb2f29b0a4ebfcbc9d69dc673960e1efb14e2d175dc506abf642e15' : 'a0daa11d1da487fa81a47921fdb025296fb76580181574050b8f543288a49371'
      when '5.6' then node['confluence']['arch'] == 'x64' ? '92c49a4137c5a7c9ead77d46f34d88ff697196ccd303ec867bcc0933208732e8' : '71f35ca19a7feb905e80073a3eff1780a7610692c77bcf67f63e6b2f270a1501'
      when '5.6.1' then node['confluence']['arch'] == 'x64' ? '28a17683b7c5018ad43064992ad4247ee70a8fea8d6c0739c7f0b605d41cb092' : '4cbe6bbac4c09c2303c8418bbcb69919bc432d5f32c59ba1f6f197e0ae239c95'
      when '5.6.3' then node['confluence']['arch'] == 'x64' ? '7cec88cd27a7deafb91f96a05b19c71613b21a72ae6432bbeee752e01fe3a023' : 'a185347ae32461cdf6fef88004d5cd776d11799dfc1ad2226051999f60d79b4d'
      when '5.6.5' then node['confluence']['arch'] == 'x64' ? 'd5bd7c13697b442cf809a1f20d7f6b68159486c04c354df0a614a3f9aeb2e0e0' : 'e003143bf92499be90fbb4d2f0f638e9b8a1f536ec9da693a06704ca0918fb19'
      when '5.7' then node['confluence']['arch'] == 'x64' ? '2017a719ff4a5bf53aea8973418b6801b6f2004e98023bbe02c778eb949a4662' : '478a7839cfa8c2ddbf21164fa49cc45ac6adb2c30072c9355df0865ea707c400'
      when '5.7.1' then node['confluence']['arch'] == 'x64' ? '916d0dd1f48ca6ac27371661a6f9160e8093aa927f3d3af13c311dd18dfc3582' : '2a9612dbebdd4879d8f7deb2a67a5f831c6f6e91a23271760ab53143168e2423'
      end
  when 'standalone'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}.zip"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then '726053c9ed8f56100bb5b3eb0ca9430e1beab73c3e26488cda1d23a42dd52dd7'
      when '5.0.1' then '43e4e80de5d1f32c73fd5829855b5a10f6d114e91e62c32caced2212a57fc2c5'
      when '5.1' then '937c3d763cbd6282d56dfa32d4ce68ffec94bb53aa8e63e7e566fd858a6ee0f9'
      when '5.1.1' then '52091a286a776e4ac7e1992e968bbee71b4239c666fd39716f3d525b2d522575'
      when '5.1.2' then 'bd60cc6d52258d873188731ca2d054a2859d7258402779928fb633a8fd0fdfea'
      when '5.1.3' then '251638b244a7a0813ddac5099ccc89012169b82c255b674a956c31b74ff00cd1'
      when '5.1.4' then 'e4e4e79202c0f949426702050b5bc6e4dd3577da35cccec04149485938f0fb25'
      when '5.1.5' then 'ae71ffc0a145d13369a13726234e73080675d9d936ebad8c106e2b63cc35bf0e'
      when '5.2.3' then '6ae70fe6a629dbc345870b09ed3acef512d6c21b45aeb10e9d3323ecc0a19393'
      when '5.2.5' then '0c54d764ad1afc8f91e5c94cd5835e69381903431b7d005048c772e4b6a033c2'
      when '5.3' then 'a87897a0e8f6f789d3e184d8b0268d36e0bd56200d17390787d7a34796a5ddec'
      when '5.5.2' then '20b45fda5493e6a1fd55f11952c851d8ae4e4afff27be5aa651b52423f4b1d4b'
      when '5.5.3' then '414f07ad27471ddf2c40f55a564e2e833c579af504aaa7154f3fb9d7f7cd5657'
      when '5.6' then 'a3fde0d6d5e240ff814af45f2bf315d47aef878d4672235fc0333b58cdf55b2b'
      when '5.6.1' then '8b11d3eda073468aa13e8b04262f002ee76e0f23a3e08fea9de2256e5dbf87bc'
      when '5.6.3' then 'f0e86bc0a8893d7f9ecb88ae300e601dab7da51a64d6ac0d73b26f047cfd69d7'
      when '5.6.5' then 'c72263d7f500e0cb167dd824920b18b481662484eba3a28bd61439a4cd605cd4'
      when '5.7' then '274deeecd770fe08d796d99a96f139d78de703ab8e27d235c57beb02b9c1c5ee'
      when '5.7.1' then '277db1d62f55466354235bc87f17604751594f665f8f0bdd4e94ab872c2ead6d'
      end
  when 'war'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-war.zip"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then 'f97cb7ca185a975769c787248784fb36d65645bc4ed70dbbac4a5b7c7ce4fc59'
      when '5.0.1' then '84130989e8dee53e6b651519667e533ac1d9676a2cac190b43f5a57222c31201'
      when '5.1' then 'e74278cf01e979a98d04cb2e9c577385123fd17dccdfe83ce853213b13911bc2'
      when '5.1.1' then 'e45c9ab6dc6f76b54c6867d295fe072f1f966cbf313342bb00477213054bc691'
      when '5.1.2' then '7f5f9909c46d9b738f2bf1865ab2f254f6801a365dbbe929fda820bd62d2e5a5'
      when '5.1.3' then '2f692293ee90f14248cf2da03e81733ba6f35d3c434c2ae63c117ccc233f9eca'
      when '5.1.4' then 'df6f179fa528812f334f2f9246d62cf6d9a70f7f1c4dc0c724f30c59102b43dc'
      when '5.1.5' then '7521ac50b50dad993fa8a9dd234b1fdd106c54e8842892e6a36f5b572db8bed6'
      when '5.2.3' then '9cf6bb41cbfde9c3a903499dd2c3521ec52eeef83cf2c77411ae95d6d30a29bb'
      when '5.2.5' then '79cda04ca2d36b71139c13b3ddd5cd26f5c38489ba11231222ff77e2fe6c7fe1'
      when '5.3' then 'f7f61c5ad821a99fa4db5c48180134fb7eba65d39700398e9c7585bd911dd04f'
      when '5.5.2' then '245355e7338ca9da9323a993fc503fba53ffb02e16b14aa131263927e89a754f'
      when '5.5.3' then '096f42c70010e9a64f7759d0e3dc9d59a15327e3754c056a5c0b39deb2b2dc63'
      when '5.6' then 'b04746861a9a681ccc38731e4c6d1ac70a0bdc6388f5134e11ad21a8fdb5587c'
      when '5.6.1' then '725346b09d9730b422673ff5abcaa07ac9ba2c980d24d653008c344916be3e16'
      when '5.6.3' then 'dc7f61fd981996792a404c3b86903ab8caeba00a9846f9b6d673e4a456fa5352'
      when '5.6.5' then '49be03f959bad432481c2e88a1d0ee5754214ad72eaa927d29172f80d45131cd'
      when '5.7' then '851497f5fdf7e7dc642b2c6be5bb609028b9b50c468c2c7f37a2e41c969ec1e2'
      when '5.7.1' then 'a144b455c164a1881c7a6652071d5caad7782149e61a3a9ba4ffd0decdfcb958'
      end
  end
else
  case node['confluence']['install_type']
  when 'cluster-standalone'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster.tar.gz"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then 'd3ca45a1358166c67bf332bceef68393195a2bf800b4ee4fea18159144dfb4eb'
      when '5.0.1' then 'b126935655bbd697bba64e69e8bc6e11fc31d73722829469ebe1a833366cca90'
      when '5.1' then 'd12b6284634348fc0abf3224094b051a39862034548472c1454308b85778aed3'
      when '5.1.1' then 'a4f30c9a7b10184cfda4e63628dc2c47322e62de2a1c6982e29865ed3bddc54e'
      when '5.1.2' then '5c1a434cca58cd5155bf27e0917ea945dc95b4255c6d3677d20cef459931df2f'
      when '5.1.3' then '12c6643698a63da7bd427b95732fa1c56e1beb1c00b6143efca397c075a91c67'
      when '5.1.4' then 'f69d25a4b3fd2a3de361000b6459d5897503e93ee84fa22f6f078139ab1fd119'
      when '5.1.5' then 'f242afe95a68e6941e543cb19a73d85f8d2423a75b076282304b33998174266c'
      when '5.2.3' then '74f1ecf6c46584eddd617ee5228d3363c1affa64eba9327fc237bbe9a705a46b'
      when '5.2.5' then '15d1d6a47f8092ba44379a330a5a8aabf23d020b3ac69ad653eadcfbb7559b90'
      when '5.3' then '4553d26782071ce94beb6399f92c9aaa6975819de58ab08f5b960273ed974f34'
      when '5.5.2' then '487b54c8b84d9667e2da24392fc580d4bdb93a32bfc28180350b1ffedd1a4dea'
      when '5.5.3' then 'ee0a5c23c41cbe6b9cf920fb84c66c8b7414ee8a2f4b9f1dd5be9f870fd14e6f'
      when '5.6' then '14115633776b35693e794844b7e140f2b426432a8d050cd663248be6d4cb3ef8'
      when '5.6.1' then 'f8cfe068abffa57023c738f186407870618a40a3c9ef1512d2ed4ec762d0adc2'
      when '5.6.3' then '33953b35697e19acc3cdfd9226253721ee04859e103213c485173f1a841dbc3c'
      when '5.6.5' then '6b84cc04924b92788b0993ea9b8480af8a770534c49ff9ee38a2f0c624db9737'
      when '5.7' then 'd413c2da91653f6ac396a7de8a40b19b2feaafae1ddd8ab9b5f8b2da0ae5bf42'
      when '5.7.1' then '9ef9c95cae85c30882ecca408734b1cb7cfdc2b9e21a277254b15227f211e426'
      end
  when 'cluster-war'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-cluster-war.tar.gz"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then 'b644b8a95edd3a79b9406c828852174133d6f18d3f853b724d3724e16d5615de'
      when '5.0.1' then 'a4945a98117830d19965fd066632245cd713b96845d5f2a444de6eb923271174'
      when '5.1' then '64f35423d53cedafc825fd17ed1130bad02de35b14c99f59cf0eadb5f0f09a96'
      when '5.1.1' then 'e407987584b05cd1e21cd1aef48a57054648335dbc1499e908f85cc0639a5276'
      when '5.1.2' then 'a2a48d5f2be4a0a4bb1f10268c0fc2acd7d2179fdb03b51d671b8a10fd96a163'
      when '5.1.3' then '4c20aa89c2a595fa5954901df2ea7cad298c9a6e34aca6d07ebf2ef697169ba3'
      when '5.1.4' then 'a10cd22e4944558b8aa6135c57cf945f9a6375acc068c4bdf46fbf976c79c8b7'
      when '5.1.5' then 'd87088c13026b8c6d2708f20af1020ad58e88042aa5428ec3a7169d587a5d723'
      when '5.2.3' then '6eae4e3956c9979139b71f4a8294dedd136a0bef4216ad47c33702ec4646a31b'
      when '5.2.5' then '59828676833c9e050c044ce068aeb4ac47e59579ba0ec90001629c27c2cb20d6'
      when '5.3' then 'a0796f1a11896774a44251a0dfa9a6de6b4f4d49cacda7b2a2aeff896ec1f7ae'
      when '5.5.2' then '75d2af82d43ba4944bffa1235a37145947c8d80520a89b71bb78e2e021fee8da'
      when '5.5.3' then 'd8a05e0a66b07072863778907e6648510ec007520003491f5e2c458ecfd98438'
      when '5.6' then '061cec104976472bf50f10df7c0eef95d69c1a2c8618e141e11d4949e04f6df2'
      when '5.6.1' then 'c45759c2b5ffd855b8aeca7a41e7bfa4783482afa4af7f1e5205cc0c11692ba8'
      when '5.6.3' then 'cc2582ee66c9ffd0b6e720710e68e618b204855b4234d41fa341605cb92f55cb'
      when '5.6.5' then '9c66ffbe02f3cfc7117e641f8c8f839952275c287fabd45df02f6f7ae77898ee'
      when '5.7' then 'f75b62f7597113a352d486e018b965081ef4908678bd24c994ab8741d57e5476'
      when '5.7.1' then 'c4021a15dffdb2496d99e2d151cf63785da4878a4c0d3addb9cabb6a88312865'
      end
  when 'installer'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-#{node['confluence']['arch']}.bin"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then node['confluence']['arch'] == 'x64' ? '03bb665b6abdc96495fca3f12683083d5e4633152f0c5cb4464779dcdd869f71' : '6612ab99ae0cf3ab240f9d9413a25bfe84b3f729cbb12ee4bee4e11a424513d0'
      when '5.0.1' then node['confluence']['arch'] == 'x64' ? '97f233a3d8f0cbedcdbdf10ce7a38cf72c091945a8281909e871828165b6ab8e' : 'b856b67564dade5930cae9590fd29ae15326e99e4b548a69b9e336d7e9659881'
      when '5.1' then node['confluence']['arch'] == 'x64' ? 'ac2cd3842b625ff6d451cf699c3b67685628cea2fd71dfbbcddcabd74f6f25eb' : '8b6acd4e807964b2c9f3fc9ced0c464183ee8ec73ddc3c8015dadb799be53c4c'
      when '5.1.1' then node['confluence']['arch'] == 'x64' ? '31bb76f8ed517c9828ada1f4a6d9b32db8eec8eb1a0ac9bf2474a861824a813f' : 'b77472844109da1a9b081d10191c77d6b6c0a50ea8ddc5ce1ddcb36a6320d14e'
      when '5.1.2' then node['confluence']['arch'] == 'x64' ? 'fc3b59471bf4ff95c4cae95e254b166c4d44b78d9d5464feb74361da7d00991c' : 'e4a7cd7545087796a12b91c577ef815ddace40f96d042d3027f22cf83ce1cace'
      when '5.1.3' then node['confluence']['arch'] == 'x64' ? '68ca52ad18a354ac721f38832088420591ebf4b7392b0e405194d7ebdc5b0e3f' : 'd2f674befaa4935c553616999efa6966e9ec0455f41026187ba50c38e05beb36'
      when '5.1.4' then node['confluence']['arch'] == 'x64' ? '5e055daf9a29c055b400df2d99aad8420433accd54a95b5c1067682ac393f25a' : '3262bb80a1e7a6df3c66b5dbbd5e26b7d3ab5941a6fb904f4ed890651933aa36'
      when '5.1.5' then node['confluence']['arch'] == 'x64' ? 'df477559705b72891385b38defa54032e1593bcf5271b3612fbcfbda86aac98e' : '3183183be7b5f0e0c5ea9af9dd562d0964abfa47d46e4720349c5b3e9339f80c'
      when '5.2.3' then node['confluence']['arch'] == 'x64' ? '5c518d54bcd06792a5eb7c62cbc031515c242fd944a0c6be64964b6d7f163bdc' : '09387b29824c507cc97fb662ff8b80dcf912c617b12420eed7b5cab3d0fa137f'
      when '5.2.5' then node['confluence']['arch'] == 'x64' ? 'c194abbc53142614adbdb0e3b6cc4a8a1106053563a02ab51a7c87189f502c1d' : 'd5efce4aaf0dccaaccdac2aeb35c2a7b025770bf05da2e84a4c89ad4de5c7b54'
      when '5.3' then node['confluence']['arch'] == 'x64' ? '4c61f3511ae3faeab11a689f26fbb82a7fc7c30525bd40c50e8854bc22b8e0be' : '5676b8fb7c8bbd1699f6cc5a8bcd7b72973bb98940bd0a56e13e5f96a6532c3d'
      when '5.5.2' then node['confluence']['arch'] == 'x64' ? '6b0361e2e25161f5e2d99380b397b5768fef835922dcb21ae34dfbc484bc203c' : '4e2ceb32cfa45085b184bbe08c7d4fbce6985487f9d12855e7fd4d0e60d9c78f'
      when '5.5.3' then node['confluence']['arch'] == 'x64' ? '0f091ecac293332f0841d80374090c5688fd413272e557d426d0b6809601030b' : '7e4be644b4fb9b58e5794029f0c733cc8537b3e1a8dd797949a8133c7d87ce73'
      when '5.6' then node['confluence']['arch'] == 'x64' ? '284a1afc2c6e22414766e7e140fed9821c81ed59cf32995ead2b4c4ecc9fa09f' : '7e3fc60e576e1a8109bb6eceb57797c0391ad81e1e025b75f19ed836846b49e2'
      when '5.6.1' then node['confluence']['arch'] == 'x64' ? '410c09200a7e81ba08e9ca27000140654e8ef1742b873456d3938ec6275aa161' : 'a0936d961c95f0c3c4e4c2f6721a46a632d03ffbfefb75f3d225689b3df76744'
      when '5.6.3' then node['confluence']['arch'] == 'x64' ? '7c9545d67dbafa4507603d9e5014ee8ba8975e057dff66edbf40acb85b92c6f8' : '7d252e8d9c092f56737a45d75b6c3643e30ce800e185981828e8419965001bb9'
      when '5.6.5' then node['confluence']['arch'] == 'x64' ? '76e882b9466068cbc3079870e97842d7823a88bc6b6a6e8cb934b6b4ad08872d' : '068e606b897e769209761c5b8097e9edf358b927109df4c4c58185e565ac2614'
      when '5.7' then node['confluence']['arch'] == 'x64' ? '3248c326a779007f9753cc1870330e2a09b8f2355466519d76ae3415b582ed52' : 'cb149a15d5052e17955042b6feaca55fabc3a76aa8b0afd19457c415fbed4540'
      when '5.7.1' then node['confluence']['arch'] == 'x64' ? '6144b112913d3114caaac93f5ee43191d22980ca704f3b53ef7725dff306d1ee' : '6c700207c0c2436f0bacf029a10f633e6d1980a60c7097773c56feec4df0b48b'
      end
  when 'standalone'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}.tar.gz"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then '18602095e4119cc5498ac14b4b5588e55f707cca73b36345b95c9a9e4c25c34d'
      when '5.0.1' then '18a497bf0899835d304e9a33431f347a28312e219d4555302e6332a3145b8191'
      when '5.1' then '3e6eced828d196bb6f18becb524c0191d4561308d71d85178fef84d5a6386203'
      when '5.1.1' then 'deb50f6dbc65b648fca9a7402d6e4ee60b0e779bbd4f1f33bc7b8344dead629e'
      when '5.1.2' then '291289c3ba7c2c59f3bcf36ca9962e022bc62946f7bdddf382529ae74242bfe2'
      when '5.1.3' then 'e400dadebe14a956d086dcb36deae2e6e12e0204ec9af49c176d62054c167903'
      when '5.1.4' then 'e615b1105c5a8a6cd16481d0e4467bd393b0a2065504a04975c5216cfd72d524'
      when '5.1.5' then '6dfbbc3404d8f96f203b01997fa7211cbf9eee491252d9f1cc5b2e84eb97f1ab'
      when '5.2.3' then '83b50558fa0f7c514b56ca56e73dbb337e725e1936b4cf2dd9c8a44b43a5e25e'
      when '5.2.5' then '98fef6163e0190d673b5ea4a3a2c8c3dd32e02d729361450515df2c4d5245892'
      when '5.3' then 'acc2f3c484bd1855b8c7c9d741da19d51a7595eed78d147d38c2c9aa63627f67'
      when '5.5.2' then '667190e9006de123e55ccc04e639321070dc65a40658ba3aa0b9d8e3473048eb'
      when '5.5.3' then '66538cba1a7925c82a2db5d438af27167c0a12dc02466d045a2f006f0f24d524'
      when '5.6' then 'a3738ea9da8012d7e93180732632d4bf782501cb25fccee960fccc6955117d68'
      when '5.6.1' then 'f8ff7ecdc742560ffeab4595200db26b3d1cb1bd0be9a93e418ae06fd6436e1c'
      when '5.6.3' then '63242c4df873f68461bcf071cf69a98fea07ec58a1e707ad5a5524cec77dcfdd'
      when '5.6.5' then '013b9fc8d20f5947637abefea1386532bb484134de57a70f7fd78d177352bd4d'
      when '5.7' then '2638d3c33585043168f6f22d7a05e09fde331d8a41080a600cd0f59c88b6ab0d'
      when '5.7.1' then '17eae4db5f08e7829f465aa6a98d7bcfe30d335afc97c52f57472c91bbe88da8'
      end
  when 'war'
    default['confluence']['url']      = "#{node['confluence']['url_base']}-#{node['confluence']['version']}-war.tar.gz"
    default['confluence']['checksum'] =
      case node['confluence']['version']
      when '4.3.7' then '2f1b3a074f083dc4cd8f38505e4fc75cab1961a8880192512482983f56aaa0d7'
      when '5.0.1' then '77d616359e1f2f3c5c4314fdd8149d926dc68406b8b9d6dfc9e0b5ac98ee611f'
      when '5.1' then '77f82bceedced6f8d58012b550f8886350dd5556d3de5eb700399a37223d08f4'
      when '5.1.1' then 'aba40aa7b2307131ff26c0b8fa78f5dc0687aa8426f23dfc39d8f31ad6322abc'
      when '5.1.2' then 'cc0170041a6f79718391fa643d29ef88aea401e478fee878790725f241a815d0'
      when '5.1.3' then '74ab320751ac9236e3d2a291cfc123b174890c68a970db06711bc1850d7aef0f'
      when '5.1.4' then '3f307d81074b347ff8ccc96538322f21644a10e74a4539f512f55d6de5471d51'
      when '5.1.5' then 'cf6773fefe2983eb961df4ca36a9c8110adc4b70690136ba39db229b8e76173b'
      when '5.2.3' then 'cad77f72fdb77f6260698c6f2d888ae2b47f5fac43ac008d3ea473af12e73218'
      when '5.2.5' then '5588f731bbd9089de9038b00467df4930b69f2840e82b646bd0459bcab05c6cb'
      when '5.3' then '13d0eafab7a3bf889b3849c0ed999afaf305ac7ac2300c08fce3cd60d81de07b'
      when '5.5.2' then '69ebcd2f1394528b5dff8b46126640a2bb62028baf2868b125a029882a72fcfd'
      when '5.5.3' then '46c49f07a02a82f3fd363b67ab40135969e80d3a16d14fefb2e58695050065a7'
      when '5.6' then '9f935f8085f33cd9eadc7876a4a1dbc5b14d31c7a313bdd26e85bf030da3057c'
      when '5.6.1' then '761e907a3e1a564561d8641bd7c9fc45a2e25679c28c4e54c28a51dec3202368'
      when '5.6.3' then '74144a7e4051a5507124c4a8ac8af5930a8598eab1b3d7f53742818c47e3a769'
      when '5.6.5' then '7f3b59276a790cea50e653fc6ac8ad4fb187bc3119c8275b7f216b374e0dedfa'
      when '5.7' then '1db7b391d11a01eebaee0c878ee1ad468f2d6788521fc13940c34c8cc24a08b6'
      when '5.7.1' then '289a727d9698d3231328a47742af1e2cca52a7c4794044ca87389af4eb87da97'
      end
  end
end
# rubocop:enable BlockNesting

default['confluence']['apache2']['access_log']         = ''
default['confluence']['apache2']['error_log']          = ''
default['confluence']['apache2']['port']               = 80
default['confluence']['apache2']['virtual_host_alias'] = node['fqdn']
default['confluence']['apache2']['virtual_host_name']  = node['hostname']

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

default['confluence']['database']['host']     = 'localhost'
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
