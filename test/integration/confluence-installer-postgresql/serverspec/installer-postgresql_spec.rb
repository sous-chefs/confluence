require 'spec_helper'

describe 'Postgresql' do
  describe port(5432) do
    it { should be_listening }
  end
end

describe 'Confluence' do
  it_behaves_like 'confluence behind the apache proxy'
end
