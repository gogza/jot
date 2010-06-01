module Jot
  module Cli
    class Main
      
      require 'trollop'

      COMMANDS = %w{lists config}

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

	@command_hash = build_command_hash(args)

	workspace = build_workspace out_stream

	jot = self.class.create_jot workspace

	cmd = @command_hash[:command]
	opts = @command_hash[:opts]

	if cmd == "tasks"
          jot.show_tasks
	elsif cmd == "lists"
          if opts[:list_name] == ""
  	    jot.show_lists
	  else
	    jot.changeCurrentListTo opts[:list_name]
          end
	elsif cmd == "config"
          if opts[:email] == nil
  	    jot.show_config
	  else
	    jot.change_config opts
          end
        end

      end

      def command_hash
        @command_hash
      end

      def build_workspace out_stream
	WorkSpace.new out_stream
      end

      def self.create_jot(workspace)
        Jot.new workspace
      end

      private
      
      def build_command_hash(args)
	cmd = args.length == 0 ? "tasks" : args.shift 

        command_hash = Hash[:command => cmd]

	opts = case cmd
          when "tasks"
	    nil	  
	  when "lists"    
	    Hash[:list_name => args * " "]
	  when "config"
	    Trollop::options args do
              opt :email, "Configuration email address", :type => :string
	      opt :api, "Configuration api", :type => :string
	    end
	  else
	    Trollop::die "unknown subcommand #{cmd.inspect}"
          end
	
	command_hash.merge!(Hash[:opts => opts]) if opts != nil

	return command_hash
      end

    end
  end
end
