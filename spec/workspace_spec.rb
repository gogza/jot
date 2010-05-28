
require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'ftools'

module Jot
  describe WorkSpace do

    def hide_original_config_file
      File.delete(BACKUP_FILENAME) if File.exist?(BACKUP_FILENAME)
      File.copy(CONFIG_FILENAME, BACKUP_FILENAME)
      File.delete(CONFIG_FILENAME)
    end

    def restore_original_config_file
      File.delete(CONFIG_FILENAME) if File.exist?(CONFIG_FILENAME) 
      File.copy(BACKUP_FILENAME, CONFIG_FILENAME)
      File.delete(BACKUP_FILENAME)
    end

    context "updating the config file" do
      before(:each) do
	hide_original_config_file
	create_test_config_file
	@output = mock("output").as_null_object
	@workspace = WorkSpace.new(@output)
	new_config = Hash["email" => "ben@bloggs.com", "api" => "4321"]
	@workspace.configuration = new_config
        @file_contents = File.read("jot.config")
      end
      after(:each) do
	restore_original_config_file
      end
      it "has saved the email to the config file" do
	@file_contents.should =~ /ben@bloggs.com/
      end
      it "has saved the email to the config file" do
	@file_contents.should =~ /4321/
      end
    end

    def create_test_config_file
      File.open(CONFIG_FILENAME, 'w') {|f| f.write(Hash["email" => "joe@bloggs.com", "api" => "ABC1234"].to_yaml)}
    end
      
    context "reading the config file" do
      before(:each) do
	hide_original_config_file
        create_test_config_file
	@output = mock("output").as_null_object
	@workspace = WorkSpace.new(@output)
      end
      after(:each) do
	restore_original_config_file
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


    context "identify current list" do
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


