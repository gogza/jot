
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe WorkSpace do
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


