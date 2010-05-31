
require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'ftools'

module Jot
  describe WorkSpace do

    def hide_file filename, backup_filename
      File.delete(backup_filename) if File.exist?(backup_filename)
      File.copy(filename, backup_filename)
      File.delete(filename)
    end

    def hide_original_config_file
      hide_file CONFIG_FILENAME, CONFIG_BACKUP_FILENAME
    end

    def restore_original_config_file
      hide_file CONFIG_BACKUP_FILENAME, CONFIG_FILENAME
    end

    def create_test_config_file
      File.open(CONFIG_FILENAME, 'w') {|f| f.write(Hash["email" => "joe@bloggs.com", "api" => "ABC1234"].to_yaml)}
    end

    def hide_original_state_file
      hide_file STATE_FILENAME, STATE_BACKUP_FILENAME
    end

    def restore_original_state_file
      hide_file STATE_BACKUP_FILENAME, STATE_FILENAME
    end

    def create_test_state_file
      File.open(STATE_FILENAME, 'w') {|f| f.write(Hash["currentList" => nil].to_yaml)}
    end
    
    describe "when managing configuration" do
      before(:each) do
	hide_original_config_file
      end

      after(:each) do
	restore_original_config_file
      end

      describe "but a config file does not exist yet" do

	context "and the config file is trying to be accessed" do

	  it "creates a new empty config file" do
    	    @output = mock("output").as_null_object
	    @workspace = WorkSpace.new(@output)
            File.exist?(CONFIG_FILENAME).should == true
	  end

	end

      end

      describe "and when a config file exists" do
        before(:each) do
          create_test_config_file
        end

        context "and we are updating the config file" do
          before(:each) do
    	    @output = mock("output").as_null_object
  	    @workspace = WorkSpace.new(@output)
  	    new_config = Hash["email" => "ben@bloggs.com", "api" => "4321"]
	    @workspace.configuration = new_config
            @file_contents = File.read("jot.config")
          end

          it "has saved the email to the config file" do
	    @file_contents.should =~ /ben@bloggs.com/
          end
          it "has saved the api to the config file" do
	    @file_contents.should =~ /4321/
          end

        end

        context "and we are reading the config file" do
          before(:each) do
	    @output = mock("output").as_null_object
	    @workspace = WorkSpace.new(@output)
          end

          it "can read the email address" do
	    @config = @workspace.configuration
            @config["email"].should == "joe@bloggs.com"
          end
          it "can read the email api" do
  	    @config = @workspace.configuration
            @config["api"].should == "ABC1234"	
          end

        end

      end

    end

    describe "when managing system state" do
      before(:each) do
	hide_original_state_file
      end

      after(:each) do
	restore_original_state_file
      end

      describe "but a state file does not exist yet" do

	context "and the state is trying to be accessed" do

	  it "creates a new empty state file" do
    	    @output = mock("output").as_null_object
	    @workspace = WorkSpace.new(@output)
            File.exist?(STATE_FILENAME).should == true
	  end

	end

      end

      describe "and a state file exists" do
        before(:each) do
  	  create_test_state_file
	end

        context "and we are identifying the current list" do
          before(:each) do
    	    @output = mock("output").as_null_object
	    @workspace = WorkSpace.new(@output)
          end
          it "identifies that the list is the current one" do
            @workspace.currentList = "This one"
	    @workspace.isCurrentList?("This one").should == true
          end
          it "identifies that the list is not the current one" do
            @workspace.currentList = "This one"
	    @workspace.isCurrentList?("Not this one").should == false
          end

        end      

      end

    end
      
  end

end


