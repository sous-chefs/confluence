settings = merge_confluence_settings

template "#{node['confluence']['install_path']}/confluence/WEB-INF/classes/crowd.properties" do
  source 'crowd.properties.erb'
  owner node['confluence']['user']
  group node['confluence']['user']
  mode 00644
  action :create
  variables(
    app_name: settings['crowd_sso']['app_name'],
    app_password: settings['crowd_sso']['app_password'],
    crowd_base_url: settings['crowd_sso']['crowd_base_url']
  )
  sensitive true
  notifies :restart, 'service[confluence]', :delayed
end

# Update config to activate Crowd's authenticator to enable SSO
# See: https://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+Confluence

default_fragment = '<authenticator class="com.atlassian.confluence.user.ConfluenceAuthenticator"/>'
sso_fragment = '<authenticator class="com.atlassian.confluence.user.ConfluenceCrowdSSOAuthenticator"/>'

ruby_block 'Set Crowd authenticator' do
  block do
    fe = Chef::Util::FileEdit.new("#{node['confluence']['install_path']}/confluence/WEB-INF/classes/seraph-config.xml")
    fe.search_file_replace(/#{Regexp.quote(default_fragment)}/, sso_fragment)
    fe.write_file
  end
  only_if %(grep '#{default_fragment}' \
    #{node['confluence']['install_path']}/confluence/WEB-INF/classes/seraph-config.xml)
  notifies :restart, 'service[confluence]', :delayed
end
