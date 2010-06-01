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
        @provider.should_receive(:lists).and_return(["Garden tasks", "House tasks"])
      end

      context "and current is set in system state" do
        before(:each) do
	  @workspace.should_receive(:isCurrentList?).with("Garden tasks").and_return(true)
          @workspace.should_receive(:isCurrentList?).with("House tasks").and_return(false)

	  @repository = ListRepository.new(@workspace)
        end

        it "should get the lists from the provider" do
          @lists = @repository.getLists
	  @lists.length.should == 2
        end
      
        it "should show the garden list" do
          @lists = @repository.getLists
          @lists.select{|list|list[:name] =~/Garden tasks/}.length.should == 1
        end

        it "should show the house list" do
          @lists = @repository.getLists
          @lists.select{|list|list[:name] =~/House tasks/}.length.should == 1
        end

        it "should mark the garden list as current" do
          @lists = @repository.getLists
          @lists.select{|list|list[:name] =~/Garden tasks/}.first[:current].should == true
        end

        it "should not mark the house list as current" do
          @lists = @repository.getLists
          @lists.select{|list|list[:name] =~/House tasks/}.first[:current].should == false
        end

      end

      context "and current is not set in system state" do
        before(:each) do
	  @workspace.should_receive(:isCurrentList?).with("Garden tasks").and_return(false)
          @workspace.should_receive(:isCurrentList?).with("House tasks").and_return(false)
	  @repository = ListRepository.new(@workspace)
        end

        it "should get the lists from the provider" do
          @lists = @repository.getLists
        end

        it "should show the garden list" do
          @lists = @repository.getLists
          @lists.select{|list|list[:name] =~/Garden tasks/}.length.should == 1
        end

        it "should show the house list" do
          @lists = @repository.getLists
          @lists.select{|list|list[:name] =~/House tasks/}.length.should == 1
        end

        it "should mark one of the lists as current" do
          @lists = @repository.getLists
          @lists.select{|list|list[:current]}.length.should == 1
        end

      end

    end

    describe "when getting tasks" do
      before(:each) do
        @provider.should_receive(:tasks_for).with(hash_including("id" =>12)).and_return(["Cut the grass", "Trim the hedge"])
      end

      context "and current is set in system state" do
        before(:each) do
	  @workspace.should_receive(:get_current_list).and_return(12)
	  @repository = ListRepository.new(@workspace)
        end

        it "should get the lists from the provider" do
          @tasks = @repository.get_current_tasks
	  @tasks.length.should == 2
        end

      end
	    
    end


  end

end

