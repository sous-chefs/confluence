# This recipe tries to autotune various settings, most notable JVM heap size.
#
# The idea and portions of the code were taken from the afklm/jira
# cookbook and its autotune recipe.
#
# See https://github.com/afklm/jira/

tune_type = 'mixed'

# Check if type is selected and if its a valid type
if node['confluence'].attribute?('autotune') && node['confluence']['autotune'].attribute?('type')
  tune_type = node['confluence']['autotune']['type']

  unless %w(mixed dedicated shared).include?(tune_type)
    Chef::Log.fatal([
      "Bad value (#{tune_type}) for node['confluence']['autotune']['type'] attribute.",
      'Valid values are one of mixed, dedicated, shared.',
    ].join(' '))
    raise
  end
end

# Parse out total_memory option, or use value detected by Ohai.
total_memory = node['memory']['total']

if node['confluence'].attribute?('autotune') && node['confluence']['autotune'].attribute?('total_memory')
  total_memory = node['confluence']['autotune']['total_memory']
  if total_memory.match(/\A\d*kB\Z/).nil?
    Chef::Application.fatal!([
      "Bad value (#{total_memory}) for node['confluence']['autotune']['total_memory'] attribute.",
      'Valid values are non-zero integers followed by kB (e.g., 49416564kB).',
    ].join(' '))
  end
end

# Ohai reports node[:memory][:total] in kB, as in "921756kB"
mem = total_memory.split('kB')[0].to_i / 1024 # in MB

maximum_memory =
  { 'mixed' => (mem / 100) * 70,
    'dedicated' => (mem / 100) * 80,
    'shared' => (mem / 100) * 50,
  }.fetch(tune_type)

node.default['confluence']['jvm']['maximum_memory'] = binround(maximum_memory * 1024 * 1024)
Chef::Log.warn("Autotuning CONFLUENCE max memory to #{node['confluence']['jvm']['maximum_memory']}.")

minimum_memory =
  { 'mixed' => (maximum_memory / 100) * 80,
    'dedicated' => maximum_memory,
    'shared' => (maximum_memory / 100) * 50,
  }.fetch(tune_type)

node.default['confluence']['jvm']['minimum_memory'] = binround(minimum_memory * 1024 * 1024)
Chef::Log.warn("Autotuning CONFLUENCE min memory to #{node['confluence']['jvm']['minimum_memory']}.")

# Lets make sure we have at least 512 MB
if minimum_memory < 512
  Chef::Log.fatal('Autotune reports less than 512 MB available for CONFLUENCE, please make at least 512 MB memory available.')
  raise
end
