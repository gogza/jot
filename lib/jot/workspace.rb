module Jot

  class WorkSpace

    def initialize (output_stream)

      @output = output_stream

      load_config

      @proxy_class = @config["proxy"] == nil ? CheckvistProxy : Kernel.const_get("Jot").const_get(@config["proxy"])

      @proxy = @proxy_class.new
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

    def clear
      File.delete(WORKSPACE_FILENAME)
    end

    def currentList= listName
      File.open(WORKSPACE_FILENAME, 'w') {|f| f.write(listName)}
    end

    def isCurrentList? listName

      return nil if !File.exist?(WORKSPACE_FILENAME)

      storedName = File.read(WORKSPACE_FILENAME)
      storedName == listName
    end
   
    def configuration
      @config
    end
    def configuration= new_config
      @config["email"] = new_config["email"]
      @config["api"] = new_config["api"]
      save_config
    end

    private

    def load_config
      @config = YAML.load(File.read(CONFIG_FILENAME))
    end

    def save_config
      File.open(CONFIG_FILENAME, 'w') {|f| f.write(@config.to_yaml)}
    end

  end

end  # module Jot

