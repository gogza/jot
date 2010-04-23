
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe WorkSpace do
    context "identify current list" do
      before(:each) do

      end
      it "identifies that the list is the current one" do
        WorkSpace.currentList = "This one"
	WorkSpace.isCurrentList?("This one").should == true
      end
      it "identifies that the list is not the current one" do
        WorkSpace.currentList = "This one"
	WorkSpace.isCurrentList?("Not this one").should == false
      end


    end

  end

end


