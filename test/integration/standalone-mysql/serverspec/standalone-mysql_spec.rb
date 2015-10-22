require 'spec_helper'

describe 'Java' do
  describe command('java -version 2>&1') do
    its(:exit_status) { should eq 0 }
  end
end

describe 'MySQL' do
  describe port(3306) do
    it { should be_listening }
  end
end

describe 'Confluence' do
  it_behaves_like 'confluence behind the apache proxy'
end
