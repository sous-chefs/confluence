# confluence_service

Creates and manages the Confluence systemd service.

## Actions

| Action     | Description                                     |
|------------|-------------------------------------------------|
| `:create`  | Creates the systemd service unit file (default) |
| `:start`   | Starts the Confluence service                   |
| `:stop`    | Stops the Confluence service                    |
| `:restart` | Restarts the Confluence service                 |
| `:enable`  | Enables the service to start on boot            |
| `:disable` | Disables the service from starting on boot      |

## Properties

| Property        | Type   | Default                                      | Description                           |
|-----------------|--------|----------------------------------------------|---------------------------------------|
| `instance_name` | String | Resource name                                | Name of the Confluence instance       |
| `install_path`  | String | `/opt/atlassian/confluence`                  | Installation directory for Confluence |
| `home_path`     | String | `/var/atlassian/application-data/confluence` | Home directory for Confluence data    |
| `user`          | String | `confluence`                                 | System user to run Confluence         |
| `group`         | String | `confluence`                                 | System group for Confluence user      |
| `service_name`  | String | `confluence`                                 | Name of the systemd service           |

## Examples

### Create and Enable Service

```ruby
confluence_service 'confluence' do
  action [:create, :enable]
end
```

### Create, Enable, and Start Service

```ruby
confluence_service 'confluence' do
  action [:create, :enable, :start]
end
```

### Restart on Configuration Change

```ruby
confluence_config 'confluence' do
  jvm_maximum_memory '4g'
  notifies :restart, 'confluence_service[confluence]', :delayed
end

confluence_service 'confluence' do
  action [:create, :enable, :start]
end
```

### Custom Service Name

```ruby
confluence_service 'production' do
  service_name 'confluence-prod'
  install_path '/opt/confluence-prod'
  home_path '/data/confluence-prod'
end
```

### Stop and Disable Service

```ruby
confluence_service 'confluence' do
  action [:stop, :disable]
end
```

## Files Managed

This resource manages the following files:

- `/etc/systemd/system/confluence.service` - systemd unit file
