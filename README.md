# chef-confluence [![Build Status](https://secure.travis-ci.org/bflad/chef-confluence.png?branch=master)](http://travis-ci.org/bflad/chef-confluence)

## Description

Installs/Configures Atlassian Confluence server. Please see COMPATIBILITY.md for more information about Confluence releases (versions and checksums) that are tested and supported by cookbook versions.

## Requirements

### Platforms

* CentOS 6.3
* RedHat 6.3
* Ubuntu 12.04

### Databases

* MySQL
* Postgres

### Cookbooks

Opscode Cookbooks (http://github.com/opscode-cookbooks/)

* apache2 (if using Apache 2 proxy)
* database
* java
* mysql (if using MySQL database)
* postgresql (if using Postgres database)

Third-Party Cookbooks

* [mysql_connector](https://github.com/bflad/chef-mysql_connector) (if using MySQL database)

### JDK/JRE

The Atlassian Confluence Linux installer will automatically configure a bundled JRE. If you wish to use your own JDK/JRE, with say the `java` cookbook, then as of this writing it must be Oracle and version 1.6/1.7 ([Supported Platforms](https://confluence.atlassian.com/display/DOC/Supported+Platforms))

Necessary configuration with `java` cookbook:
* `node['java']['install_flavor'] = "oracle"`
* `node['java']['oracle']['accept_oracle_download_terms'] = true`
* `recipe[java]`

## Attributes

These attributes are under the `node['confluence']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
version | Confluence version to install | String | 2.1.1
url | URL for Confluence installer .tar.gz | String | `http://www.atlassian.com/software/confluence/downloads/binary/atlassian-stash-#{node['confluence']['version']}.tar.gz`
checksum | SHA256 checksum for Confluence installer .tar.gz | String | see attributes/default.rb
install_path | location to install Confluence | String | /opt/atlassian-confluence
user | user to run Confluence | String | confluence
home_path | home directory for Confluence user | String | `/home/#{node['confluence']['user']}`

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
port | Tomcat HTTP port | Fixnum | 7990
ssl_port | Tomcat HTTPS port | Fixnum | 8443

## Recipes

* `recipe[confluence]` Installs Atlassian Confluence with built-in Tomcat
* `recipe[confluence::apache2]` Installs above with Apache 2 proxy (ports 80/443)

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

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create confluence`
  * `knife data bag edit confluence confluence --secret-file=path/to/secret`
* Add `recipe[confluence]` to your node's run list.

### Confluence Server Installation with Apache 2 Frontend

* Optionally (un)encrypted data bag or set attributes
  * `knife data bag create confluence`
  * `knife data bag edit confluence confluence --secret-file=path/to/secret`
* Add `recipe[confluence::apache2]` to your node's run list.

## Testing and Development

Here's how you can quickly get testing or developing against the cookbook thanks to [Vagrant](http://vagrantup.com/) and [Berkshelf](http://berkshelf.com/).

    gem install bundler --no-ri --no-rdoc
    git clone git://github.com/bflad/chef-confluence.git
    cd chef-confluence
    bundle install
    bundle exec vagrant up BOX # BOX being centos6 or ubuntu1204

You may need to add the following hosts entries:

* 33.33.33.10 confluence-centos-6
* 33.33.33.11 confluence-ubuntu-1204

The running Confluence server is accessible from the host machine:

CentOS 6 Box:
* Web UI: https://33.33.33.10/

Ubuntu 12.04 Box:
* Web UI: https://33.33.33.11/

You can then SSH into the running VM using the `vagrant ssh` command.
The VM can easily be stopped and deleted with the `vagrant destroy`
command. Please see the official [Vagrant documentation](http://vagrantup.com/v1/docs/commands.html)
for a more in depth explanation of available commands.

## Contributing

Please use standard Github issues/pull requests and if possible, in combination with testing on the Vagrant boxes.

## License and Author

Author:: Brian Flad (<bflad@wharton.upenn.edu>)

Copyright:: 2013

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
