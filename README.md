# Confluence Cookbook
[![Cookbook Version](https://img.shields.io/cookbook/v/confluence.svg)](https://supermarket.chef.io/cookbooks/confluence)
[![Build Status](https://travis-ci.org/parallels-cookbooks/confluence.svg?branch=master)](https://travis-ci.org/parallels-cookbooks/confluence)

## Call for maintainer

Please, see this [issue](https://github.com/parallels-cookbooks/confluence/issues/162)

## Description

Installs/Configures an instance of [Atlassian Confluence](https://www.atlassian.com/software/confluence/).

## Requirements

### Platforms

* RHEL/CentOS 6, 7
* Ubuntu 14.04, 16.04

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

If you prefer Confluence standalone installation, then you have to manage JDK/JRE 8
([Supported Platforms](https://confluence.atlassian.com/display/DOC/Supported+Platforms))
on this node. It can be done with `java` cookbook and appropricate attributes:

```ruby
node.default['java']['jdk_version'] = "8"
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
version | Confluence version to install | String | 6.1.2

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
type | Confluence database type - "mysql", "postgresql", or "hsqldb" | String | mysql
user | Confluence database user | String | confluence

### Confluence JVM Attributes

These attributes are under the `node['confluence']['jvm']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
minimum_memory | JVM minimum memory | String | 512m
maximum_memory | JVM maximum memory | String | 768m
maximum_permgen | JVM maximum PermGen memory | String | 256m
java_opts | additional JAVA_OPTS to be passed to Confluence JVM during startup | String | ""
bundled_jre | prefer JRE bundled with linux installer | Boolean | true

### Confluence Autotune Attributes

These attributes are under the `node['confluence']['autotune']` namespace. Autotune automatically determines appropriate settings for certain
attributes. This feature is inspired by the `autotune` recipe in the https://github.com/afklm/jira cookbook. This
initial version only supports JVM min and max memory size tuning.

There are several tuning types that can be set:

* 'mixed' - Confluence and DB run on the same system
* 'dedicated' - Confluence has the system all to itself
* 'shared' - Confluence shares the system with the DB and other applications

Total available memory is auto discovered using Ohai but can be overridden by setting your own value in kB.

Attribute    | Description                                                           | Type    | Default
-------------|-----------------------------------------------------------------------|---------|------------
enabled      | Whether or not to autotune settings.                                  | Boolean | false
type         | Type of tuning to apply. One of 'mixed', 'dedicated' and 'shared'.    | String  | mixed
total_memory | Total system memory to use for autotune calculations.                 | String  | Ohai value



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
      "name": "confluence_db",
      "user": "confluence_user",
      "password": "confluence_db_password"
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

## Sponsors

Development of this cookbook has been generously supported in part by
the code contributions of the following organizations:

* [University of Pennsylvania](http://www.upenn.edu/)
* [Parallels International GmbH](https://www.parallels.com)
* [Blended Perspectives Inc.](http://www.blendedperspectives.com/)

## License and Author

* Author:: Mikhail Zholobov (legal90@gmail.com, @legal90)
* Author:: Azat Khadiev (anuriq@gmail.com, @anuriq)
* Author:: Brian Flad (<bflad417@gmail.com>, @bflad)
* Author:: Denny Schäfer (<trash4you@online.de>, @tuxinaut)
* Copyright:: 2013, Brian Flad
* Copyright:: 2013, University of Pennsylvania
* Copyright:: 2013, Denny Schäfer
* Copyright:: 2016-2017, Parallels International GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
