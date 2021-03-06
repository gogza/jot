module Jot

    class Jot

    CURRENT_MARKER = "*"
    CURRENT_PREFIX = " #{CURRENT_MARKER} "
    EMPTY_PREFIX = " " * CURRENT_PREFIX.length

    def initialize(workspace)
      @output = workspace.output_stream
      @workspace = workspace
      @repository = workspace.repository
    end

    def show_lists
      @output.puts
      display_lists
    end

    def show_tasks
      @output.puts
      tasks = @repository.get_current_tasks

      if tasks == nil
        @output.puts "<empty>" 
	return
      end

      display_tasks tasks
    end

    def display_tasks tasks, no_of_spaces = 3
      tasks.each do |task|
	prefix = " " * no_of_spaces 
        @output.puts(prefix + task["content"])
	if task["children"] != nil
	  display_tasks task["children"], no_of_spaces + 2
	end
      end
    end

    def change_current_list_to list_name
      @output.puts
      begin

        list = @repository.find_single_list list_name
	@repository.make_current_list list

      rescue MoreThanOneMatchError
        @output.puts "Hold on! Jot found more than one matching list.\n\n"
      rescue NoMatchError
        @output.puts "Sorry, Jot can't find a matching list.\n\n"
      end

      display_lists

    end

    def show_config
      config = @workspace.configuration
      @output.puts
      config.each_pair {|k,v| @output.puts "#{k}: #{v}"}
    end

    def change_config config
      new_config = Hash["email" => config[:email], "api" => config[:api]]
      @workspace.configuration = new_config
    end

    private

    def display_lists
      @lists = @repository.getLists
      
      @lists.each {|list| 
	prefix = list["current"] ? CURRENT_PREFIX : EMPTY_PREFIX
        @output.puts prefix + list["name"]
      }

    end

  end

end

