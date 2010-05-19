module Jot

  class CheckvistListProvider
    def initialize(proxy)
      @proxy = proxy
    end

    def lists
      lists = @proxy.getCheckLists
      lists.map{|list| list["name"]}
    end
  end

end
