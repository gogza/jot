module Jot

  class WorkSpace

    def initialize (output_stream)

      @output = output_stream

      @config = load_config
      @state = load_state

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

    def currentList= listName
      @state["currentList"] = listName

      save_state

    end

    def isCurrentList? listName

      @state["currentList"] == listName

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
      load_yaml CONFIG_FILENAME, Hash["email" => nil, "api" => nil]
    end

    def save_config
      save_yaml CONFIG_FILENAME, @config
    end

    def load_state
      load_yaml STATE_FILENAME, Hash["currentList" => nil]
    end

    def save_state
      save_yaml STATE_FILENAME, @state
    end

    def load_yaml filename, default
      File.open(filename, 'w') do
        |f| f.write(default.to_yaml)
      end if !File.exist?(filename)
	    
      YAML.load(File.read(filename))
    end

    def save_yaml filename, value
      File.open(filename, 'w') {|f| f.write(value.to_yaml)}
    end

  end

  class PersistantHash
    def initialize (filename, default)
      @filename = filename
      @default = default
      @hash = load
    end

    def save hash
      @hash = hash
      File.open(@filename, 'w') {|f| f.write(@hash.to_yaml)}
    end

    def to_hash
      @hash
    end

    private

    def load
      File.open(@filename, 'w') do
        |f| f.write(@default.to_yaml)
      end if !File.exist?(@filename)
	    
      YAML.load(File.read(@filename))
    end



  end 


end  # module Jot

