
require File.join(File.dirname(__FILE__), %w[spec_helper])

module Jot::Cli
  describe Main do

    def execute_cli (cli_input)
      input = cli_input.split(" ")
      input.shift if input[0] == "jot"
      @output = mock("output").as_null_object
      Main.new(input,@output, Jot::CheckvistProxyMock)
    end	   

    context "processing configuration command" do
      before(:each) do
        @jot = mock("jot").as_null_object
        Main.should_receive(:create_jot).and_return(@jot)
      end
      it "puts the config command in the hash" do
	
	main = execute_cli "jot config" 
	main.command_hash[:command].should == "config"

      end
      it "asks jot to show the configuration" do
	@jot.should_receive(:show_config)
	main = execute_cli "jot config" 
      end
    end

    context "processing configuration arguments" do
      before(:each) do
        @jot = mock("jot").as_null_object
        Main.should_receive(:create_jot).and_return(@jot)
      end
      
      def act
        @main = execute_cli "jot config -e joe@bloggs.com -a abc123"
      end

      it "puts the config command into the hash" do 
        act
	@main.command_hash[:command].should == "config"
      end
      it "puts the email address into a hash" do
	act
	@main.command_hash[:opts][:email].should == "joe@bloggs.com"
      end
      it "puts the api into a hash" do      
        act
	@main.command_hash[:opts][:api].should == "abc123"
      end
      it "asks jot to change the email configuration" do
	@jot.should_receive(:change_config).with(hash_including({:email => "joe@bloggs.com"}))
	act      
      end
      it "asks jot to change the api configuration" do
	@jot.should_receive(:change_config).with(hash_including({:api => "abc123"}))
	act      
      end
    end
  end

end


