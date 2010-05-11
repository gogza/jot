
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe Jot do
    context "viewing configuration" do
      before(:each) do
	@output = mock("output stream").as_null_object
	@workspace = mock("workspace").as_null_object
	@workspace.should_receive(:output_stream).and_return(@output)
	state = Hash["email" => "joe@bloggs.com", "api" => "1234"]
	@workspace.should_receive(:configuration).and_return(state)
        @jot = Jot.new(@workspace)
      end

      it "should display the email" do
	@output.should_receive(:puts).with(/email: joe.bloggs.com/)
	@jot.show_config
      end 
      it "should display the api" do
	@output.should_receive(:puts).with(/api: 1234/)
	@jot.show_config
      end 
    end

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

