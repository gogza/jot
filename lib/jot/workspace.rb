module Jot

  class WorkSpace

    def initialize (output_stream)

      @output = output_stream

      @config = PersistantHash.new(CONFIG_FILENAME, Hash["email" => nil, "api" => nil])
      @state = PersistantHash.new(STATE_FILENAME,  Hash["currentListId" => nil])

      @proxy_class = @config["proxy"] == nil ? CheckvistProxy : Kernel.const_get("Jot").const_get(@config["proxy"])

      @proxy = @proxy_class.new @config["email"], @config["api"]
      @provider = CheckvistListProvider.new @proxy
      @repository = ListRepository.new self
    end

    def output_stream
      @output	   
    end
 
    def repository
      @repository
    end

    def provider
      @provider
    end

    def currentList= list_id
      
      @state["currentListId"] = list_id.to_i

      @state.save

    end

    def isCurrentList? list

      @state["currentListId"] == list["id"]

    end

    def get_current_list
      @state["currentListId"] == nil ? nil : @state["currentListId"].to_i
    end
   
    def configuration
      @config.to_hash
    end

    def configuration= new_config

      @config["email"] = new_config["email"]
      @config["api"] = new_config["api"]

      @config.save
    end

  end

end  # module Jot

