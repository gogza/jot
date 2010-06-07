require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe ListRepository do
    before(:each) do
      @provider = mock("List Provider").as_null_object
      @workspace = mock("workspace").as_null_object
      @workspace.should_receive(:provider).and_return(@provider)
    end

    describe "when getting lists" do
      before(:each) do
	@garden_list = {"id" => 12, "name" => "Garden tasks"}
	@house_list = {"id" => 13, "name" => "House tasks"}
        @provider.should_receive(:lists).and_return([@garden_list, @house_list])
      end

      context "and current is set in system state" do
        before(:each) do
	  @workspace.should_receive(:get_current_list).and_return(@garden_list["id"])

	  @repository = ListRepository.new(@workspace)
        end

        it "should get the lists from the provider" do
          @lists = @repository.getLists
	  @lists.length.should == 2
        end
      
        it "should show the garden list" do
          @lists = @repository.getLists
          @lists.select{|list|list["name"] =~/Garden tasks/}.length.should == 1
        end

        it "should show the house list" do
          @lists = @repository.getLists
          @lists.select{|list|list["name"] =~/House tasks/}.length.should == 1
        end

        it "should mark the garden list as current" do
          @lists = @repository.getLists
          @lists.select{|list|list["name"] =~/Garden tasks/}.first["current"].should == true
        end

        it "should not mark the house list as current" do
          @lists = @repository.getLists
          @lists.select{|list|list["name"] =~/House tasks/}.first["current"].should == false
        end

      end

      context "and current is not set in system state" do
        before(:each) do
	  @workspace.should_receive(:get_current_list).and_return(nil)
	  @repository = ListRepository.new(@workspace)
        end

        it "should get the lists from the provider" do
          @lists = @repository.getLists
        end

        it "should show the garden list" do
          @lists = @repository.getLists
          @lists.select{|list|list["name"] =~/Garden tasks/}.length.should == 1
        end

        it "should show the house list" do
          @lists = @repository.getLists
          @lists.select{|list|list["name"] =~/House tasks/}.length.should == 1
        end

        it "should mark one of the lists as current" do
          @lists = @repository.getLists
          @lists.select{|list|list["current"]}.length.should == 1
        end

      end

    end

    describe "when getting tasks" do
      before(:each) do
      end

      describe "and current list is set in system state" do
        before(:each) do
          @workspace.should_receive(:get_current_list).and_return(12)
	end

        context "and all the tasks are at the same level" do
          before(:each) do
	    tasks = build_hash_tasks [[1, "Cut the grass", 0, ""],[2, "Trim the hedge", 0, ""]]
            @provider.should_receive(:tasks_for).with(hash_including("id" =>12)).and_return(tasks)
	    @repository = ListRepository.new(@workspace)
          end

          it "should both tasks" do
            @tasks = @repository.get_current_tasks
	    @tasks.length.should == 2
          end

	  it "should return the content of both tasks" do
            @tasks = @repository.get_current_tasks
	    (@tasks.select {|task| task["content"] =~ /Cut the grass/}).length.should == 1
	    (@tasks.select {|task| task["content"] =~ /Trim the hedge/}).length.should == 1
          end

	  it "neither task should have children" do
            @tasks = @repository.get_current_tasks
	    (@tasks.select {|task| task["content"] =~ /Cut the grass/}).first["children"].should == nil
	    (@tasks.select {|task| task["content"] =~ /Trim the hedge/}).first["children"].should == nil
          end

	end

        context "and the tasks are hierarchically arranged" do
          before(:each) do
	    tasks = build_hash_tasks [[10, "Tidy up", 0, "1,2"],[1, "Cut the grass", 10, ""],[2, "Trim the hedge", 10, ""]]
            @provider.should_receive(:tasks_for).with(hash_including("id" =>12)).and_return(tasks)
	    @repository = ListRepository.new(@workspace)
          end

          it "should get just one task at the top level" do
            @tasks = @repository.get_current_tasks
	    @tasks.length.should == 1
          end

	  it "should return the tidy up task at the top level" do
            @tasks = @repository.get_current_tasks
	    (@tasks.select {|task| task["content"] =~ /Tidy up/}).length.should == 1
          end

	  it "should return the other tasks as children of the tidy up task" do
            @tasks = @repository.get_current_tasks
            first_kids = @tasks.first["children"]
	    (first_kids.select {|task| task["content"] =~ /Cut the grass/}).length.should == 1
	    (first_kids.select {|task| task["content"] =~ /Trim the hedge/}).length.should == 1
          end


	end


      end
	    
    end


  end

end

