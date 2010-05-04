
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe ListRepository do
    context "getting lists when current is set in the WorkSpace" do
      before(:each) do
	@provider = mock("List Provider").as_null_object
	@provider.should_receive(:lists).and_return(["Garden tasks", "House tasks"])
        ListProviderFactory.should_receive(:provider).and_return(@provider)
        WorkSpace.should_receive(:isCurrentList?).with("Garden tasks").and_return(true)
        WorkSpace.should_receive(:isCurrentList?).with("House tasks").and_return(false)
      end
#      it "should get a list provider from the List Provider Factory" do
#        ListProviderFactory.should_receive(:provider)
#        @lists = ListRepository.getLists
#      end

#      it "should get the lists from the provider" do
#        @lists = ListRepository.getLists
#	@provider.should_receive(:lists)
#      end
      
#      it "should show the garden list" do
#        @lists = ListRepository.getLists
#	@lists.name.should == "stecet"

        # @lists.select{|list|[:name] =~/Garden tasks/}.length.should == 1
#      end
#      it "should show the house list" do
#        @lists = ListRepository.getLists
#        @lists.select{|list|[:name] =~/House tasks/}.length.should == 1
#      end
#      it "should mark the garden list as current" do
#        @lists = ListRepository.getLists
#        @lists.select{|list|[:name] =~/Garden tasks/}[:current].should_be_true
#      end
#      it "should not mark the house list as current" do
#        @lists = ListRepository.getLists
#        @lists.select{|list|[:name] =~/Garden tasks/}[:current].should_be_false
#      end

#    end

#    context "viewing list when current is not set" do
#      before(:each) do
#	@provider = mock("List Provider").as_null_object
##	@provider.should_receive(:lists).and_return(["Garden tasks", "House tasks"])
#        ListProviderFactory.should_receive(:getProvider).and_return(@provider)
#	WorkSpace.should_receive(:isCurrentList?).with("Garden tasks").and_return(false)
#        WorkSpace.should_receive(:isCurrentList?).with("House tasks").and_return(false)

#	@output = mock("output buffer").as_null_object

#	@jot = Jot.new(@output)

#      end
#      it "should get the lists from the provider" do
#        @lists = ListRepository.getLists
#      end
#      it "should show the garden list" do
#        @lists = ListRepository.getLists
#        @lists.select{|list|[:name] =~/Garden tasks/}.length.should == 1
#      end
#      it "should show the house list" do
#        @lists = ListRepository.getLists
#        @lists.select{|list|[:name] =~/House tasks/}.length.should == 1
#      end
#      it "should mark one of the lists as current" do
#        @lists = ListRepository.getLists
#        @lists.select{|list|[:current]}.length.should == 1
#      end

    end

  end

end

