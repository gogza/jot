
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe WorkSpace do

    context "updating the config file" do
      before(:each) do
	@output = mock("output").as_null_object
	@workspace = WorkSpace.new(@output, CheckvistProxyMock)
	new_config = Hash["email" => "ben@bloggs.com", "api" => "4321"]
	@workspace.configuration = new_config
        @file_contents = File.read("jot.config")
      end
      it "has saved the email to the config file" do
	@file_contents.should =~ /ben@bloggs.com/
      end
      it "has saved the email to the config file" do
	@file_contents.should =~ /4321/
      end
    end	    
      
    context "reading the config file" do
      before(:each) do
	File.delete("jot.config")
        File.open("jot.config", 'w') {|f| f.write(Hash["email" => "joe@bloggs.com", "api" => "ABC1234"].to_yaml)}

	@output = mock("output").as_null_object
	@workspace = WorkSpace.new(@output, CheckvistProxyMock)

      end
      it "can read the email address" do
	@config = @workspace.configuration
        @config["email"].should == "joe@bloggs.com"
      end
      it "can read the email api" do
	@config = @workspace.configuration
        @config["api"].should == "ABC1234"	
      end

    end


    context "identify current list" do
      before(:each) do
	@output = mock("output").as_null_object
	@workspace = WorkSpace.new(@output, CheckvistProxyMock)
      end
      it "identifies that the list is the current one" do
        @workspace.currentList = "This one"
	@workspace.isCurrentList?("This one").should == true
      end
      it "identifies that the list is not the current one" do
        @workspace.currentList = "This one"
	@workspace.isCurrentList?("Not this one").should == false
      end


    end

  end

end


