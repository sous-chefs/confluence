# chef-confluence
[![Cookbook Version](https://img.shields.io/cookbook/v/confluence.svg)](https://supermarket.chef.io/cookbooks/confluence)
[![Build Status](https://secure.travis-ci.org/parallels-cookbooks/confluence.png?branch=master)](http://travis-ci.org/parallels-cookbooks/confluence)

## Description

Installs/Configures Atlassian Confluence server. Please see [COMPATIBILITY.md](COMPATIBILITY.md) for more information about Confluence releases that are tested and supported by this cookbook and its versions.

## Requirements

### Platforms

* CentOS 6
* RedHat 6
* Ubuntu 12.04

### Databases

* MySQL
* Postgres

### Cookbooks

Required [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apache2](https://github.com/opscode-cookbooks/apache2) (if using Apache 2 proxy)
* [database](https://github.com/opscode-cookbooks/database)
* [mysql](https://github.com/opscode-cookbooks/mysql) (if using MySQL database)
* [postgresql](https://github.com/opscode-cookbooks/postgresql) (if using Postgres database)

Required Third-Party Cookbooks

* [mysql_connector](https://github.com/bflad/chef-mysql_connector) (if using MySQL database)

Suggested [Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [java](https://github.com/opscode-cookbooks/java)

### JDK/JRE

The Atlassian Confluence Linux installer will automatically configure a bundled JRE.

If you prefer Confluence stadalone installation, then you have to manage JDK/JRE 8
([Supported Platforms](https://confluence.atlassian.com/display/DOC/Supported+Platforms))
on this node. It can be done with `java` cookbook and appropricate attributes:

* `node['java']['jdk_version'] = "8"`
* `recipe[java]`

## Attributes

These attributes are under the `node['confluence']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
checksum | SHA256 checksum for Confluence install | String | auto-detected (see attributes/default.rb)
home_path | home directory for Confluence user | String | /var/atlassian/application-data/confluence
install_path | location to install Confluence | String | /opt/atlassian/confluence
install_type | Confluence install type - "installer", "standalone" | String | installer
url_base | URL base for Confluence install | String | http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence
url | URL for Confluence install | String | auto-detected (see attributes/default.rb)
user | user running Confluence | String | confluence
version | Confluence version to install | String | 5.8.8

### Confluence Database Attributes

All of these `node['confluence']['database']` attributes are overridden by `confluence/confluence` encrypted data bag (Hosted Chef) or data bag (Chef Solo), if it exists

Attribute | Description | Type | Default
----------|-------------|------|--------
host | FQDN or "localhost" (localhost automatically installs `['database']['type']` server) | String | localhost
name | Confluence database name | String | confluence
password | Confluence database user password | String | changeit
port | Confluence database port | Fixnum | 3306
type | Confluence database type - "mysql" or "postgresql" | String | mysql
user | Confluence database user | String | confluence

### Confluence JVM Attributes

These attributes are under the `node['confluence']['jvm']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
minimum_memory | JVM minimum memory | String | 512m
maximum_memory | JVM maximum memory | String | 768m
maximum_permgen | JVM maximum PermGen memory | String | 256m
java_opts | additional JAVA_OPTS to be passed to Confluence JVM during startup | String | ""

### Confluence Tomcat Attributes

These attributes are under the `node['confluence']['tomcat']` namespace.

Any `node['confluence']['tomcat']['key*']` attributes are overridden by `confluence/confluence` encrypted data bag (Hosted Chef) or data bag (Chef Solo), if it exists

Attribute | Description | Type | Default
----------|-------------|------|--------
keyAlias | Tomcat SSL keystore alias | String | tomcat
keystoreFile | Tomcat SSL keystore file - will automatically generate self-signed keystore file if left as default | String | `#{node['confluence']['home_path']}/.keystore`
keystorePass | Tomcat SSL keystore passphrase | String | changeit
port | Tomcat HTTP port | Fixnum | 8090
ssl_port | Tomcat HTTPS port | Fixnum | 8443

## Recipes

* `recipe[confluence]` Installs/configures Atlassian Confluence
* `recipe[confluence::apache2]` Installs/configures Apache 2 as proxy (ports 80/443)
* `recipe[confluence::database]` Installs/configures MySQL/Postgres server, database, and user for Confluence
* `recipe[confluence::linux_installer]` Installs/configures Confluence via Linux installer"
* `recipe[confluence::linux_standalone]` Installs/configures Confluence via Linux standalone archive"
* `recipe[confluence::tomcat_configuration]` Configures Confluence's built-in Tomcat

## Usage

### Confluence Server Data Bag

For securely overriding attributes on Hosted Chef, create a `confluence/confluence` encrypted data bag with the model below. Chef Solo can override the same attributes with a `confluence/confluence` unencrypted data bag of the same information.

_required:_
* `['database']['type']` "mysql" or "postgresql"
* `['database']['host']` FQDN or "localhost" (localhost automatically
  installs `['database']['type']` server)
* `['database']['name']` Name of Confluence database
* `['database']['user']` Confluence database username
* `['database']['password']` Confluence database username password

_optional:_
* `['database']['port']` Database port, standard database port for
  `['database']['type']`
* `['tomcat']['keyAlias']` Tomcat HTTPS Java Keystore keyAlias, defaults to self-signed certifcate
* `['tomcat']['keystoreFile']` Tomcat HTTPS Java Keystore keystoreFile, self-signed certificate
* `['tomcat']['keystorePass']` Tomcat HTTPS Java Keystore keystorePass, self-signed certificate

Repeat for other Chef environments as necessary. Example:

    {
      "id": "confluence"
      "development": {
        "database": {
          "type": "postgresql",
          "host": "localhost",
          "name": "confluence",
          "user": "confluence",
          "password": "confluence_db_password",
        },
        "tomcat": {
          "keyAlias": "not_tomcat",
          "keystoreFile": "/etc/pki/java/wildcard_cert.jks",
          "keystorePass": "not_changeit"
        }
      }
    }

### Confluence Server Installation

The simplest method is via the default recipe, which uses `node['confluence']['install_type']` to determine best method.

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create confluence`
  * `knife data bag edit confluence confluence --secret-file=path/to/secret`
* Add `recipe[confluence]` to your node's run list.

### Custom Confluence Configurations

Using individual recipes, you can use this cookbook to configure Confluence to fit your environment.

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create confluence`
  * `knife data bag edit confluence confluence --secret-file=path/to/secret`
* Add individual recipes to your node's run list.

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/) and [Berkshelf](http://berkshelf.com/).

    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-cachier
    vagrant plugin install vagrant-omnibus
    git clone git://github.com/bflad/chef-confluence.git
    cd chef-confluence
    vagrant up BOX # BOX being centos5, centos6, debian7, fedora18, fedora19, fedora20, freebsd9, ubuntu1204, ubuntu1210, ubuntu1304, or ubuntu1310

You may need to add the following hosts entries:

* 192.168.50.10 confluence-centos-6
* 192.168.50.10 confluence-ubuntu-1204
* (etc.)

The running Confluence server is accessible from the host machine:

CentOS 6 Box:
* Web UI: https://confluence-centos-6/

Ubuntu 12.04 Box:
* Web UI: https://confluence-ubuntu-1204/

You can then SSH into the running VM using the `vagrant ssh BOX` # BOX being centos6 or ubuntu1204 command.
The VM can easily be stopped and deleted with the `vagrant destroy`
command. Please see the official [Vagrant documentation](http://docs.vagrantup.com/v2/cli/index.html)
for a more in depth explanation of available commands.

#### Test-Kitchen

Test-Kitchen is preconfigured to work with Vagrant to integration
testing.

If your system isn't powerful enough for speedy local testing, this
cookbook is pre-configured to easily use remote servers with
DigitalOcean:

```
ln -s .kitchen.digitalocean.yml .kitchen.local.yml
# Get key ID by inspecting DOM of web dashboard on keys page
export DIGITALOCEAN_ACCESS_TOKEN=xxxxxxxxxxxx DIGITALOCEAN_SSH_KEY_IDS=123456
bundle install
bundle exec kitchen list
```

## Contributing

Please use standard Github issues/pull requests and if possible, in combination with testing on the Vagrant boxes.

## Sponsors

Development of this cookbook has been generously supported in part by
the code contributions of the following organizations:

* [University of Pennsylvania](http://www.upenn.edu/)
* [Parallels Inc.](https://www.parallels.com)
* [Blended Perspectives Inc.](http://www.blendedperspectives.com/)

## License and Author

* Author:: Brian Flad (<bflad417@gmail.com>, @bflad)
* Author:: Denny Schäfer (<trash4you@online.de>, @tuxinaut)
* Copyright:: 2013, Brian Flad
* Copyright:: 2013, University of Pennsylvania
* Copyright:: 2013, Denny Schäfer

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
