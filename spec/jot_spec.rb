
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe Jot do
    context "viewing list when current is set" do
      before(:each) do
	@provider = mock("List Provider").as_null_object
	@provider.should_receive(:lists).and_return(["Garden tasks", "House tasks"])
        ListProviderFactory.should_receive(:getProvider).and_return(@provider)
	WorkSpace.should_receive(:isCurrentList?).with("Garden tasks").and_return(true)
        WorkSpace.should_receive(:isCurrentList?).with("House tasks").and_return(false)

	@output = mock("output buffer").as_null_object

	@jot = Jot.new(@output)

      end
      it "should get the lists from the provider" do
	@jot.show_lists
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

    context "viewing list when current is not set" do
      before(:each) do
	@provider = mock("List Provider").as_null_object
	@provider.should_receive(:lists).and_return(["Garden tasks", "House tasks"])
        ListProviderFactory.should_receive(:getProvider).and_return(@provider)
	WorkSpace.should_receive(:isCurrentList?).with("Garden tasks").and_return(false)
        WorkSpace.should_receive(:isCurrentList?).with("House tasks").and_return(false)

	@output = mock("output buffer").as_null_object

	@jot = Jot.new(@output)

      end
      it "should get the lists from the provider" do
	@jot.show_lists
      end
      it "should show the garden list" do
        @output.should_receive(:puts).with(/Garden tasks/)
	@jot.show_lists
      end
      it "should show the house list" do
        @output.should_receive(:puts).with(/House tasks/)
	@jot.show_lists
      end
      it "should mark one of the lists as current" do
        @output.should_receive(:puts).once.with(/ \* /)
	@jot.show_lists
      end

    end


  end

end

