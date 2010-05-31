module Jot

  class CheckvistProxy

    require "open-uri"

    HOST = "http://checkvist.com"

    def initialize email, api_key
      @email = email
      @api_key = api_key
    end

    def getCheckLists
      json_call "/checklists.json"
    end

    def json_call url, parameters = nil
    
      res = open(HOST + url, :http_basic_authentication => [@email, @api_key])
    
      JSON.parse(res.string)

    end
    
  end

end  # module Jot

