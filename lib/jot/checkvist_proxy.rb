module Jot

  class CheckvistProxy

    require "open-uri"

    def initialize
      @email = "mail.gordon.mcallister@gmail.com"
      @api_key = "clsg9rHHPZK46pxIqMilcIAuGMftKtUNh5vMaCAs"
      @url = URI.parse("http://checkvist.com")
    end

    def getCheckLists
      json_call "/checklists.json"
    end

    def json_call url, parameters = nil
    
      res = open(@url.to_s + url, :http_basic_authentication => [@email, @api_key])
    
      JSON.parse(res.string)

    end
    
  end

  class CheckvistProxyMock

    @@lists = []

    def getCheckLists
      @@lists.map {|list| Hash["name" => list] }
    end

    def self.add_list(list_name)
      @@lists << list_name
    end

    def self.clear
      @@lists = []
    end

  end

end  # module Jot

