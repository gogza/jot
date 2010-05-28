module Jot

  class CheckvistProxy

    require "open-uri"

    def initialize email, api_key
      @email = email
      @api_key = api_key
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

end  # module Jot

