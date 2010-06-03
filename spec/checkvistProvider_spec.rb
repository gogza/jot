require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot

  describe CheckvistListProvider do
    before(:each) do
      @proxy = mock("List Proxy")
    end

    context "providing lists" do

      before(:each) do
	@proxy.stub!(:getCheckLists).and_return(JSON.parse( open("spec/data/checklists.json").read))

	@provider = CheckvistListProvider.new(@proxy)
      end

      it "should provide the House list" do
        house_lists = @provider.lists.select {|list| list["name"] =~ /House tasks/ }
	house_lists.length.should == 1
      end

      it "should provide the Garden list" do
        garden_lists = @provider.lists.select {|list| list["name"] =~ /Garden tasks/ }
	garden_lists.length.should == 1
      end

    end

    context "providing tasks" do

      before(:each) do
	@proxy.should_receive(:get_tasks_for).with(hash_including("id" => 12)).and_return(JSON.parse( open("spec/data/list.json").read))

	@provider = CheckvistListProvider.new(@proxy)
      end

      it "should provide the tasks for list 12" do
        tasks = @provider.tasks_for({"id"=> 12})
	tasks.length.should == 11
      end

    end

  end

end
