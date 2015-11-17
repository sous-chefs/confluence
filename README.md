# chef-confluence
[![Cookbook Version](https://img.shields.io/cookbook/v/confluence.svg)](https://supermarket.chef.io/cookbooks/confluence)
[![Build Status](https://secure.travis-ci.org/parallels-cookbooks/confluence.png?branch=master)](http://travis-ci.org/parallels-cookbooks/confluence)

## Description

Installs/Configures Atlassian Confluence server. Please see [COMPATIBILITY.md](COMPATIBILITY.md) for more information about Confluence releases that are tested and supported by this cookbook and its versions.

## Requirements

### Platforms

* RHEL/CentOS 6, 7
* Ubuntu 12.04, 14.04

### Cookbooks

* [apache2](https://github.com/svanzoest-cookbooks/apache2)
* [ark](https://github.com/burtlo/ark)
* [database](https://github.com/chef-cookbooks/database)
* [java](https://github.com/agileorbit-cookbooks/java)
* [mysql](https://github.com/chef-cookbooks/mysql)
* [mysql_connector](https://github.com/bflad/chef-mysql_connector)
* [mysql2_chef_gem](https://github.com/chef-cookbooks/mysql_chef_gem)
* [postgresql](https://github.com/hw-cookbooks/postgresql)

### JDK/JRE

The Atlassian Confluence Linux installer will automatically configure a bundled JRE.

If you prefer Confluence stadalone installation, then you have to manage JDK/JRE 8
([Supported Platforms](https://confluence.atlassian.com/display/DOC/Supported+Platforms))
on this node. It can be done with `java` cookbook and appropricate attributes:

```ruby
node.set['java']['jdk_version'] = "8"
include_recipe 'java'
```

## Attributes

These attributes are under the `node['confluence']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
checksum | SHA256 checksum for Confluence install | String | auto-detected by library method
home_path | home directory for Confluence user | String | /var/atlassian/application-data/confluence
install_path | location to install Confluence | String | /opt/atlassian/confluence
install_type | Confluence install type - "installer", "standalone" | String | installer
url | URL for Confluence install | String | auto-detected by library method
user | user running Confluence | String | confluence
version | Confluence version to install | String | 5.8.16

**Notice:** If `['confluence']['install_type']` is set to `installer`, then the installer will try to upgrade your Confluence instance located in `['confluence']['install_path']` (if it exists) to the `['confluence']['version']`.

If you want to avoid an unexpected upgrade, just set or override `['confluence']['version']` attribute value to that of your current confluence version.

### Confluence Database Attributes

These attributes are under the `node['confluence']['database']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
host | FQDN or IP of database server ("127.0.0.1" automatically installs `['database']['type']` server) | String | "127.0.0.1"
name | Confluence database name | String | confluence
password | Confluence database user password | String | changeit
port | Confluence database port | Fixnum | 3306 for MySQL, 5432 for PostgreSQL
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

Attribute | Description | Type | Default
----------|-------------|------|--------
port | Tomcat HTTP port | Fixnum | 8090

## Recipes

* `recipe[confluence]` Installs/configures Atlassian Confluence
* `recipe[confluence::apache2]` Installs/configures Apache 2 as proxy (ports 80/443)
* `recipe[confluence::database]` Installs/configures MySQL/Postgres server, database, and user for Confluence
* `recipe[confluence::linux_installer]` Installs/configures Confluence via Linux installer"
* `recipe[confluence::linux_standalone]` Installs/configures Confluence via Linux standalone archive"
* `recipe[confluence::tomcat_configuration]` Configures Confluence's built-in Tomcat
* `recipe[confluence::crowd_sso]` Configures user authentication with Crowd single sign-on

## Usage

### Confluence Data Bag

For security purposes it is recommended to use data bag for storing secrets
like passwords and database credentials.

You can override any attributes from the `['confluence']` namespace using the
`confluence/confluence` data bag. It could be either encrypted or not
encrypted by your choice.

Example:
```json
{
  "id": "confluence",
  "confluence": {
    "database": {
      "type": "postgresql",
      "host": "localhost",
      "name": "confluence_db",
      "user": "confluence_user",
      "password": "confluence_db_password",
    }
  }
}
```
_(Note - `"confluence"` nesting level is required!)_

These credentials will be used for your Confluence installation instead of
appropriate attribute values.

Data bag's and item's names are optional and can be changed by overriding
attributes `['confluence']['data_bag_name']` and `['confluence']['data_bag_item']`

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

#### Releasing

To release a new version of the cookbook to the Supermarket community
site:

```
bundle exec developement:publish
```

This will confirm that the git workspace is clean, and create a tag
(formatted `v1.9.0`) based on metadata, then push to Supermarket. (You
will be prompted to configure the command if you haven't already.)

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
