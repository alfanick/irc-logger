require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/frontend" do
  before(:each) do
    @response = request("/frontend")
  end
end