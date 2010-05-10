module Jot
  module Cli
    class Main
      
      require 'trollop'

      COMMANDS = %w{lists}

      def self.execute(args)
        new(args)
      end

      def initialize(args, out_stream = STDOUT)
        version = File.read("version.txt")

	global_opts = Trollop::options(args) do
	  version "Jot #{version} (c) 2010 Gordon McAllister"
          banner = "Command line front end for Checkvist"
          stop_on COMMANDS
        end

	cmd = args.shift

	opts = case cmd
	  when "lists"    
	    Hash[:command => cmd, :opts => Hash[:list_name => args * " "]]
	  when "config"
	    Hash[:command => cmd]
	  else
	    Trollop::die "unknown subcommand #{cmd.inspect}"
          end
	
	workspace = self.class.create_workspace

	jot = Jot.new(workspace)

	if opts[:command] == "lists"
          if opts[:opts][:list_name] == ""
  	    jot.show_lists
	  else
            puts "!!!!! \"#{opts[:opts][:list_name]}\""
	    jot.changeCurrentListTo opts[:opts][:list_name]
          end
	else
	 jot.show_config
        end

      end

      def self.create_workspace
	WorkSpace.new
      end

    end
  end
end
