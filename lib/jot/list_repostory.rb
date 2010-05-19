module Jot

  MoreThanOneMatchError = Class.new(StandardError)
  NoMatchError = Class.new(StandardError)

  class ListRepository
    
    def initialize(workspace)
      @workspace = workspace
      @provider = workspace.provider
    end
    
    def getLists
    
      lists = @provider.lists
      currentHasBeenFound = false

      listsWithCurrent = lists.map {|item|
	if @workspace.isCurrentList?(item)
          current = true
	  currentHasBeenFound = true
	else
	  current = false	
	end
	Hash[:current => current, :name => item]
      }

      if !currentHasBeenFound
        listsWithCurrent[0][:current] = true
	@workspace.currentList = listsWithCurrent[0][:name]
      end

      return listsWithCurrent
    end

    def findSingleList criteria

      criteria = Regexp.new(criteria) if criteria.kind_of? String

      lists = @provider.lists

      foundLists = lists.select {|list| list =~ criteria }
      
      raise NoMatchError, "No list matches the criteria" if foundLists.length == 0
      raise MoreThanOneMatchError, "More than one list matches the criteria" if foundLists.length !=1

      Hash[:name => foundLists[0]]

    end

    def makeCurrent list
      @workspace.currentList = list[:name]
    end

  end

end


