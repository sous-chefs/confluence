require 'spec_helper'

describe 'confluence::tomcat_configuration' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
