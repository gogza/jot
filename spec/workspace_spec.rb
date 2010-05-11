
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe WorkSpace do
    context "reading the config file" do
      before(:each) do
	File.delete("jot.config")
        File.open("jot.config", 'w') {|f| f.write(Hash["email" => "joe@bloggs.com", "api" => "ABC1234"].to_yaml)}

        @workspace = WorkSpace.new

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
        @workspace = WorkSpace.new
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


