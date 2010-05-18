
module Jot

  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    @version ||= File.read(path('version.txt')).strip
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args, &block )
    rv =  args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
    if block
      begin
        $LOAD_PATH.unshift LIBPATH
        rv = block.call
      ensure
        $LOAD_PATH.shift
      end
    end
    return rv
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args, &block )
    rv = args.empty? ? PATH : ::File.join(PATH, args.flatten)
    if block
      begin
        $LOAD_PATH.unshift PATH
        rv = block.call
      ensure
        $LOAD_PATH.shift
      end
    end
    return rv
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

  require 'net/http'
  require 'rubygems'
  require 'json'

  class Jot

    EMPTY_PREFIX = "   "
    CURRENT_PREFIX = " * "

    def initialize(workspace)
      @output = workspace.output_stream
      @workspace = workspace
      @repository = workspace.repository
    end

    def show_lists
      @output.puts
      display_lists
    end

    def changeCurrentListTo listName
      @output.puts
      begin

        list = @repository.findSingleList listName
	@repository.makeCurrent list

      rescue MoreThanOneMatchError
        @output.puts "Hold on! Jot found more than one matching list.\n\n"
      rescue NoMatchError
        @output.puts "Sorry, Jot can't find a matching list.\n\n"
      end

      display_lists

    end

    def show_config
      configuration = @workspace.configuration
      @output.puts
      @output.puts "email: #{configuration["email"]}"
      @output.puts "api: #{configuration["api"]}"
    end

    def change_config config
      new_config = Hash["email" => config[:email], "api" => config[:api]]
      @workspace.configuration = new_config
    end

    private

    def display_lists
      @lists = @repository.getLists

      @lists.each {|list| 
	prefix = list[:current] ? CURRENT_PREFIX : EMPTY_PREFIX
        @output.puts prefix + list[:name] 
      }
    end

  end

  MoreThanOneMatchError = Class.new(StandardError)
  NoMatchError = Class.new(StandardError)

  class ListRepository
    
    def initialize(workspace)
      @workspace = workspace
      @provider = workspace.provider
    end
    
    def getLists
    
      lists = @provider.lists
      currentHasBeenFound = false

      listsWithCurrent = lists.map {|item|
	if @workspace.isCurrentList?(item)
          current = true
	  currentHasBeenFound = true
	else
	  current = false	
	end
	Hash[:current => current, :name => item]
      }

      if !currentHasBeenFound
        listsWithCurrent[0][:current] = true
	@workspace.currentList = listsWithCurrent[0][:name]
      end

      return listsWithCurrent
    end

    def findSingleList criteria

      criteria = Regexp.new(criteria) if criteria.kind_of? String

      lists = @provider.lists

      foundLists = lists.select {|list| list =~ criteria }
      
      raise NoMatchError, "No list matches the criteria" if foundLists.length == 0
      raise MoreThanOneMatchError, "More than one list matches the criteria" if foundLists.length !=1

      Hash[:name => foundLists[0]]

    end

    def makeCurrent list
      @workspace.currentList = list[:name]
    end

  end

  class ListProviderFactory

    @@provider = nil

    def self.getProvider
      @@provider = CheckvistListProvider.new(CheckvistProxy.new) if @@provider == nil
      @@provider
    end
  end

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

  class WorkSpace

    #WORKSPACE_FILENAME = ".workspace"
    #CONFIG_FILENAME = "jot.config"

    def initialize (output_stream, proxy_class)
      @proxy_class = proxy_class
      @output = output_stream
      @proxy = @proxy_class.new
      @provider = CheckvistListProvider.new @proxy
      @repository = ListRepository.new self
      load_config
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

  class CheckvistListProvider
    def initialize(proxy)
      @proxy = proxy
    end

    def lists
      lists = @proxy.getCheckLists
      lists.map{|list| list["name"]}
    end
  end

  class CheckvistProviderImpersonator
    @@lists = []

    def self.add_list(list_name)
      @@lists << list_name
    end

    def lists
      @@lists	    
    end

  end


end  # module Jot

Jot.require_all_libs_relative_to(__FILE__)

