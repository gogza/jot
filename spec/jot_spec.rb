
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe Jot do
    context "viewing list" do
      before(:each) do
	@provider = mock("List Provider").as_null_object
	@provider.should_receive(:lists).and_return(["Garden tasks", "House tasks"])
        ListProviderFactory.should_receive(:getProvider).and_return(@provider)

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

    end

  end

end

