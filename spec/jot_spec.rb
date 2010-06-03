
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot
  describe Jot do
    before(:each) do
      @output = mock("output stream").as_null_object
      @workspace = mock("workspace").as_null_object
      @workspace.should_receive(:output_stream).and_return(@output)
    end

    context "changing the configuration" do
      before(:each) do
        @jot = Jot.new(@workspace)
	@new_config = Hash[:email => "ben@bloggs.com",:api => "4321"]
      end

      it "should write to the new email address to configuration" do
	@workspace.should_receive(:configuration=).with(hash_including({"email" => "ben@bloggs.com"}))
	@jot.change_config(@new_config)
      end

      it "should write to the new api to configuration" do
	@workspace.should_receive(:configuration=).with(hash_including({"api" => "4321"}))
	@jot.change_config(@new_config)
      end
    end

    context "viewing configuration" do
      before(:each) do
	config = Hash["email" => "joe@bloggs.com", "api" => "1234"]
	@workspace.should_receive(:configuration).and_return(config)
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

    describe "and jot performs some domain manipulation" do
      before(:each) do
        @repository = mock("repository").as_null_object
	@workspace.should_receive(:repository).and_return(@repository)
      end

      context "viewing list" do
        before(:each) do
      	  list = [Hash["current" => true, "name" => "Garden tasks"], Hash["current" => false, "name" => "House tasks"]]

   	  @repository.should_receive(:getLists).and_return(list)

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
	
      context "changing the current list" do
        before(:each) do 
	  @list_name = "House tasks"
	  @list = {"id" => 13, "name" => @list_name}	
	  @jot = Jot.new(@workspace)
	end

      	it "should find the list from the repository" do
  	  @repository.should_receive(:find_single_list).with(@list_name).and_return(@list)
 	  @jot.change_current_list_to @list_name
        end
	      
        it "should get the repository to make the list current" do
  	  @repository.should_receive(:find_single_list).with(@list_name).and_return(@list)
	  @repository.should_receive(:make_current_list).with(@list)

 	  @jot.change_current_list_to @list_name
        end

		
      end


      describe "viewing tasks" do

        context "when there is only one task" do
          before(:each) do 
  	    tasks = [{"content" => "Cut the grass"}]
            @repository.should_receive(:get_current_tasks).and_return(tasks)
  	    @jot = Jot.new(@workspace)
          end
		
          it "should get the current tasks from the repository" do
            @jot.show_tasks
          end
          it "should show the only task" do
  	    @output.should_receive(:puts).with(/Cut the grass/)      
            @jot.show_tasks
          end
        end

        context "when there are more than one task" do
          before(:each) do 
  	    tasks = [{"content" => "Cut the grass"}, {"content" => "Trim the hedge"}]
            @repository.should_receive(:get_current_tasks).and_return(tasks)
  	    @jot = Jot.new(@workspace)
          end
		
          it "should get the current tasks from the repository" do
            @jot.show_tasks
          end
          it "should show all the tasks" do
  	    @output.should_receive(:puts).with(/Cut the grass/)      
  	    @output.should_receive(:puts).with(/Trim the hedge/)      
            @jot.show_tasks
          end
        end

      end

    end

  end

end

