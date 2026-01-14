# confluence_config

Configures Confluence JVM settings, Tomcat connector, and home directory.

## Actions

| Action    | Description                                              |
|-----------|----------------------------------------------------------|
| `:create` | Creates/updates Confluence configuration files (default) |

## Properties

| Property                       | Type    | Default                                      | Description                                               |
|--------------------------------|---------|----------------------------------------------|-----------------------------------------------------------|
| `instance_name`                | String  | Resource name                                | Name of the Confluence instance                           |
| `install_path`                 | String  | `/opt/atlassian/confluence`                  | Installation directory for Confluence                     |
| `home_path`                    | String  | `/var/atlassian/application-data/confluence` | Home directory for Confluence data                        |
| `user`                         | String  | `confluence`                                 | System user to run Confluence                             |
| `group`                        | String  | `confluence`                                 | System group for Confluence user                          |
| `jvm_minimum_memory`           | String  | `256m`                                       | JVM minimum heap size (e.g., 256m, 1g)                    |
| `jvm_maximum_memory`           | String  | `1024m`                                      | JVM maximum heap size (e.g., 1024m, 2g)                   |
| `jvm_support_recommended_args` | String  | `''`                                         | Additional JVM arguments recommended by Atlassian support |
| `catalina_opts`                | String  | `''`                                         | Additional CATALINA_OPTS for Tomcat                       |
| `tomcat_port`                  | String  | `8090`                                       | Tomcat HTTP connector port                                |
| `tomcat_shutdown_port`         | String  | `8000`                                       | Tomcat shutdown port                                      |
| `tomcat_max_threads`           | String  | `150`                                        | Maximum number of request processing threads              |
| `tomcat_accept_count`          | String  | `100`                                        | Maximum queue length for incoming connections             |
| `tomcat_proxy_name`            | String  | `nil`                                        | Proxy server name (for reverse proxy setups)              |
| `tomcat_proxy_port`            | String  | `nil`                                        | Proxy server port (for reverse proxy setups)              |
| `tomcat_scheme`                | String  | `http`                                       | URL scheme (`http` or `https`)                            |
| `tomcat_secure`                | Boolean | `false`                                      | Whether the connector is secure                           |
| `template_cookbook`            | String  | `confluence`                                 | Cookbook to source templates from                         |

## Examples

### Basic Configuration

```ruby
confluence_config 'confluence' do
  jvm_minimum_memory '512m'
  jvm_maximum_memory '2g'
end
```

### Reverse Proxy Configuration (HTTPS)

When running Confluence behind a reverse proxy (nginx, Apache, HAProxy):

```ruby
confluence_config 'confluence' do
  jvm_minimum_memory '1g'
  jvm_maximum_memory '4g'
  tomcat_port '8090'
  tomcat_proxy_name 'confluence.example.com'
  tomcat_proxy_port '443'
  tomcat_scheme 'https'
  tomcat_secure true
end
```

### High-Traffic Configuration

```ruby
confluence_config 'confluence' do
  jvm_minimum_memory '2g'
  jvm_maximum_memory '8g'
  tomcat_max_threads '200'
  tomcat_accept_count '150'
end
```

### With Support-Recommended JVM Args

```ruby
confluence_config 'confluence' do
  jvm_minimum_memory '1g'
  jvm_maximum_memory '4g'
  jvm_support_recommended_args '-Dconfluence.upgrade.recovery.file.enabled=false'
end
```

### Custom Templates

```ruby
confluence_config 'confluence' do
  template_cookbook 'my_wrapper_cookbook'
end
```

## Files Managed

This resource manages the following files:

- `{install_path}/confluence/WEB-INF/classes/confluence-init.properties` - Home directory configuration
- `{install_path}/bin/setenv.sh` - JVM and environment settings
- `{install_path}/conf/server.xml` - Tomcat connector configuration
