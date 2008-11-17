require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a guy exists" do
  Guy.all.destroy!
  request(resource(:guys), :method => "POST", 
    :params => { :guy => { :id => nil }})
end

describe "resource(:guys)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:guys))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of guys" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a guy exists" do
    before(:each) do
      @response = request(resource(:guys))
    end
    
    it "has a list of guys" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Guy.all.destroy!
      @response = request(resource(:guys), :method => "POST", 
        :params => { :guy => { :id => nil }})
    end
    
    it "redirects to resource(:guys)" do
      @response.should redirect_to(resource(Guy.first), :message => {:notice => "guy was successfully created"})
    end
    
  end
end

describe "resource(@guy)" do 
  describe "a successful DELETE", :given => "a guy exists" do
     before(:each) do
       @response = request(resource(Guy.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:guys))
     end

   end
end

describe "resource(:guys, :new)" do
  before(:each) do
    @response = request(resource(:guys, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@guy, :edit)", :given => "a guy exists" do
  before(:each) do
    @response = request(resource(Guy.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@guy)", :given => "a guy exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Guy.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @guy = Guy.first
      @response = request(resource(@guy), :method => "PUT", 
        :params => { :guy => {:id => @guy.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@guy))
    end
  end
  
end

