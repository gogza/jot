
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe Jot do
    context "viewing list" do
      before(:each) do
	list = [Hash[:current => true, :name => "Garden tasks"], Hash[:current => false, :name => "House tasks"]]

	@repository = mock("repository").as_null_object
	@repository.should_receive(:getLists).and_return(list)
	@output = mock("output buffer").as_null_object
        @workspace = mock("workspace").as_null_object
	@workspace.should_receive(:output_stream).and_return(@output)
	@workspace.should_receive(:repository).and_return(@repository)

	@jot = Jot.new(@workspace)

      end
      it "should show the garden list" do
        @output.should_receive(:puts).with(/Garden tasks/)
	@jot.show_lists
      end
      it "should show the house list" do
        @output.should_receive(:puts).with(/House tasks/)
	@jot.show_lists
      end
      it "should mark the garden list as current" do
        @output.should_receive(:puts).with(/ * Garden tasks/)
	@jot.show_lists
      end
      it "should not mark the house list as current" do
        @output.should_receive(:puts).with(/   House tasks/)
	@jot.show_lists
      end

    end

  end

end

