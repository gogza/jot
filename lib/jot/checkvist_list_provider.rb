module Jot

  class CheckvistListProvider
    def initialize(proxy)
      @proxy = proxy
    end

    def lists
      lists = @proxy.getCheckLists
      #lists.map{|list| list["name"]}
    end

    def tasks_for list
      @proxy.get_tasks_for list
    end
  end

end
