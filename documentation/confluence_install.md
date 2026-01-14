# confluence_install

Downloads and installs Atlassian Confluence standalone tarball.

## Actions

| Action     | Description                                   |
|------------|-----------------------------------------------|
| `:install` | Downloads and installs Confluence (default)   |
| `:remove`  | Removes the Confluence installation directory |

## Properties

| Property        | Type   | Default                                      | Description                              |
|-----------------|--------|----------------------------------------------|------------------------------------------|
| `instance_name` | String | Resource name                                | Name of the Confluence instance          |
| `version`       | String | **Required**                                 | Version of Confluence to install         |
| `install_path`  | String | `/opt/atlassian/confluence`                  | Installation directory for Confluence    |
| `home_path`     | String | `/var/atlassian/application-data/confluence` | Home directory for Confluence data       |
| `user`          | String | `confluence`                                 | System user to run Confluence            |
| `group`         | String | `confluence`                                 | System group for Confluence user         |
| `url`           | String | Auto-generated                               | URL to download Confluence from          |
| `checksum`      | String | `nil`                                        | SHA256 checksum of the download artifact |

## Examples

### Basic Installation

```ruby
confluence_install 'confluence' do
  version '8.5.4'
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
```

### Custom Download URL

```ruby
confluence_install 'confluence' do
  version '8.5.4'
  url 'https://internal-mirror.example.com/confluence-8.5.4.tar.gz'
  checksum 'abc123...'
end
```

### Remove Installation

```ruby
confluence_install 'confluence' do
  install_path '/opt/atlassian/confluence'
  action :remove
end
```
