module Jot

  class PersistantHash
    def initialize (filename, default)
      @filename = filename
      @default = default
      @hash = load
    end

    def [] key
      @hash[key]
    end

    def []= key, value
      @hash[key] = value
    end

    def save
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
