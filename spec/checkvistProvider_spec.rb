require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot

  describe CheckvistListProvider do

    context "providing lists" do

      before(:each) do
	proxy = mock("List Proxy")
	proxy.stub!(:getCheckLists).and_return(JSON.parse( open("spec/data/checklists.json").read))

	@provider = CheckvistListProvider.new(proxy)
      end

      it "should show the house list" do
        @provider.lists.should include("House tasks")
      end

      it "should provide the garden list" do
        @provider.lists.should include("Garden tasks")
      end


    end

  end

end
