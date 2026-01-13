# Confluence Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/confluence.svg)](https://supermarket.chef.io/cookbooks/confluence)
[![CI State](https://github.com/sous-chefs/confluence/workflows/ci/badge.svg)](https://github.com/sous-chefs/confluence/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures [Atlassian Confluence](https://www.atlassian.com/software/confluence/) using custom resources.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you'd like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- AlmaLinux 8, 9
- Amazon Linux 2023
- CentOS Stream 9
- Debian 12
- Fedora (latest)
- Oracle Linux 8, 9
- Red Hat Enterprise Linux 8, 9
- Rocky Linux 8, 9
- Ubuntu 22.04, 24.04

### Chef

- Chef 16+

### Cookbooks

None - this cookbook has no external cookbook dependencies.

## Resources

- [confluence_install](documentation/confluence_install.md) - Downloads and installs Confluence
- [confluence_config](documentation/confluence_config.md) - Configures JVM and Tomcat settings
- [confluence_service](documentation/confluence_service.md) - Manages the systemd service

## Quick Start

```ruby
# Install Confluence
confluence_install 'confluence' do
  version '8.5.4'
end

# Configure Confluence
confluence_config 'confluence' do
  jvm_minimum_memory '1g'
  jvm_maximum_memory '4g'
end

# Create and start the service
confluence_service 'confluence' do
  action [:create, :enable, :start]
end
```

## Usage Examples

### Basic Installation

```ruby
confluence_install 'confluence' do
  version '8.5.4'
end

confluence_config 'confluence' do
  jvm_minimum_memory '512m'
  jvm_maximum_memory '2g'
  tomcat_port '8090'
end

confluence_service 'confluence' do
  action [:create, :enable]
end
```

### Behind a Reverse Proxy (HTTPS)

When running Confluence behind nginx, Apache, or HAProxy:

```ruby
confluence_install 'confluence' do
  version '8.5.4'
end

confluence_config 'confluence' do
  jvm_minimum_memory '1g'
  jvm_maximum_memory '4g'
  tomcat_port '8090'
  tomcat_proxy_name 'confluence.example.com'
  tomcat_proxy_port '443'
  tomcat_scheme 'https'
  tomcat_secure true
end

confluence_service 'confluence' do
  action [:create, :enable, :start]
end
```

### Custom Paths

```ruby
confluence_install 'confluence' do
  version '8.5.4'
  install_path '/opt/confluence'
  home_path '/data/confluence'
  user 'atlassian'
  group 'atlassian'
end

confluence_config 'confluence' do
  install_path '/opt/confluence'
  home_path '/data/confluence'
  user 'atlassian'
  group 'atlassian'
  jvm_maximum_memory '4g'
end

confluence_service 'confluence' do
  install_path '/opt/confluence'
  home_path '/data/confluence'
  user 'atlassian'
  group 'atlassian'
  action [:create, :enable, :start]
end
```

## Database Configuration

This cookbook does **not** manage database installation or configuration. You must set up your database separately using your preferred method:

- [postgresql cookbook](https://github.com/sous-chefs/postgresql)
- [mysql cookbook](https://github.com/sous-chefs/mysql)
- External managed database (RDS, Cloud SQL, etc.)

Configure the database connection through Confluence's web-based setup wizard after installation.

## Reverse Proxy Configuration

This cookbook does **not** manage reverse proxy configuration. Set up your reverse proxy separately using:

- [nginx cookbook](https://github.com/sous-chefs/nginx)
- [apache2 cookbook](https://github.com/sous-chefs/apache2)
- [haproxy cookbook](https://github.com/sous-chefs/haproxy)

Use the `tomcat_proxy_name`, `tomcat_proxy_port`, `tomcat_scheme`, and `tomcat_secure` properties on `confluence_config` to configure Confluence for reverse proxy operation.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
