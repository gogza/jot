module Jot

  class CheckvistProxy

    require "open-uri"

    def initialize
      @email = "mail.gordon.mcallister@gmail.com"
      @api_key = "clsg9rHHPZK46pxIqMilcIAuGMftKtUNh5vMaCAs"
      @host = URI.parse("http://checkvist.com")
    end

    def getCheckLists
      json_call "/checklists.json"
    end

    def json_call url, parameters = nil
    
      res = open(@host.to_s + url, :http_basic_authentication => [@email, @api_key])
    
      JSON.parse(res.string)

    end
    
  end

  class CheckvistProxyMock

    @@lists = []
    @@visited_url = []

    def initialize host
      @host = host
    end

    def getCheckLists
      @@visited_url << @host + "/checklists.json"
      @@lists.map {|list| Hash["name" => list] }
    end

    def self.add_list(list_name)
      @@lists << list_name
    end

    def self.clear
      @@lists = []
      @@visited_url = []
    end

    def self.has_visited url
      @@visited_url.include? url
    end

  end

end  # module Jot

