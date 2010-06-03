module Jot

  MoreThanOneMatchError = Class.new(StandardError)
  NoMatchError = Class.new(StandardError)

  class ListRepository
    
    def initialize(workspace)
      @workspace = workspace
      @provider = workspace.provider
    end

    def get_current_tasks
      current_list = @workspace.get_current_list
      @provider.tasks_for({"id" => current_list})
    end
    
    def getLists
    
      lists = @provider.lists

      currentListId = @workspace.get_current_list

      currentHasBeenFound = currentListId != nil

      listsWithCurrent = lists.map {|item|
	if item["id"] == currentListId
          current = true
	else
	  current = false	
	end
	item["current"] = current
	item
      }

      if !currentHasBeenFound
        listsWithCurrent[0]["current"] = true
	@workspace.currentList = listsWithCurrent[0]["id"]
      end

      return listsWithCurrent
    end

    def find_single_list criteria

      criteria = Regexp.new(criteria) if criteria.kind_of? String

      lists = @provider.lists

      foundLists = lists.select {|list| list["name"] =~ criteria }
           
      raise NoMatchError, "No list matches the criteria" if foundLists.length == 0
      raise MoreThanOneMatchError, "More than one list matches the criteria" if foundLists.length !=1

      foundLists.first

    end

    def make_current_list list
      @workspace.currentList = list["id"]
    end

  end

end


