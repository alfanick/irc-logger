require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a message exists" do
  Message.all.destroy!
  request(resource(:messages), :method => "POST", 
    :params => { :message => { :id => nil }})
end

describe "resource(:messages)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:messages))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of messages" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a message exists" do
    before(:each) do
      @response = request(resource(:messages))
    end
    
    it "has a list of messages" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Message.all.destroy!
      @response = request(resource(:messages), :method => "POST", 
        :params => { :message => { :id => nil }})
    end
    
    it "redirects to resource(:messages)" do
      @response.should redirect_to(resource(Message.first), :message => {:notice => "message was successfully created"})
    end
    
  end
end

describe "resource(@message)" do 
  describe "a successful DELETE", :given => "a message exists" do
     before(:each) do
       @response = request(resource(Message.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:messages))
     end

   end
end

describe "resource(:messages, :new)" do
  before(:each) do
    @response = request(resource(:messages, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@message, :edit)", :given => "a message exists" do
  before(:each) do
    @response = request(resource(Message.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@message)", :given => "a message exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Message.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @message = Message.first
      @response = request(resource(@message), :method => "PUT", 
        :params => { :message => {:id => @message.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@message))
    end
  end
  
end

