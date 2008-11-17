require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a channel exists" do
  Channel.all.destroy!
  request(resource(:channels), :method => "POST", 
    :params => { :channel => { :id => nil }})
end

describe "resource(:channels)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:channels))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of channels" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a channel exists" do
    before(:each) do
      @response = request(resource(:channels))
    end
    
    it "has a list of channels" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Channel.all.destroy!
      @response = request(resource(:channels), :method => "POST", 
        :params => { :channel => { :id => nil }})
    end
    
    it "redirects to resource(:channels)" do
      @response.should redirect_to(resource(Channel.first), :message => {:notice => "channel was successfully created"})
    end
    
  end
end

describe "resource(@channel)" do 
  describe "a successful DELETE", :given => "a channel exists" do
     before(:each) do
       @response = request(resource(Channel.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:channels))
     end

   end
end

describe "resource(:channels, :new)" do
  before(:each) do
    @response = request(resource(:channels, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@channel, :edit)", :given => "a channel exists" do
  before(:each) do
    @response = request(resource(Channel.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@channel)", :given => "a channel exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Channel.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @channel = Channel.first
      @response = request(resource(@channel), :method => "PUT", 
        :params => { :channel => {:id => @channel.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@channel))
    end
  end
  
end

