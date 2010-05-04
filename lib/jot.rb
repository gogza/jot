
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

    def initialize(output_buffer)
      @output = output_buffer
    end

    def show_lists
      @output.puts
      display_lists
    end

    def changeCurrentListTo listName
      @output.puts
      begin

        list = ListRepository.findSingleList listName
	ListRepository.makeCurrent list

      rescue MoreThanOneMatchError
        @output.puts "Hold on! Jot found more than one matching list.\n\n"
      rescue NoMatchError
        @output.puts "Sorry, jot can't find a matching list.\n\n"
      end

      display_lists

    end

    private	

    def display_lists
      @lists = ListRepository.getLists

      @lists.each {|list| 
	prefix = list[:current] ? " * " : "   "
        @output.puts prefix + list[:name] 
      }
    end

  end

  MoreThanOneMatchError = Class.new(StandardError)
  NoMatchError = Class.new(StandardError)

  class ListRepository

    @@listProvider = nil

    def self.getLists
      #setProvider

      lists = ListProviderFactory.provider.lists
      currentHasBeenFound = false

      listsWithCurrent = lists.map {|item|
	if WorkSpace.isCurrentList?(item)
          current = true
	  currentHasBeenFound = true
	else
	  current = false	
	end
	Hash[:current => current, :name => item]
      }

      if !currentHasBeenFound
        listsWithCurrent[0][:current] = true
	WorkSpace.currentList = listsWithCurrent[0][:name]
      end

      return listsWithCurrent
    end

    def self.findSingleList criteria
      #setProvider
      criteria = Regexp.new(criteria) if criteria.kind_of? String

      lists = ListProviderFactory.provider.lists

      foundLists = lists.select {|list| list =~ criteria }
      
      raise NoMatchError, "No list matches the criteria" if foundLists.length == 0
      raise MoreThanOneMatchError, "More than one list matches the criteria" if foundLists.length !=1

      Hash[:name => foundLists[0]]

    end

    def self.makeCurrent list
      WorkSpace.currentList = list[:name]
    end

    private

    def self.setProvider
      @@listProvider = ListProviderFactory.getProvider if @@listProvider == nil
    end

  end

  class ListProviderFactory

    @@provider = nil

    def self.provider
      @@provider = CheckvistListProvider.new(CheckvistProxy.new) if @@provider == nil
      @@provider
    end
  end

  class CheckvistProxy

    def initialize
      @email = "mail.gordon.mcallister@gmail.com"
      @api_key = "clsg9rHHPZK46pxIqMilcIAuGMftKtUNh5vMaCAs"
      @url = URI.parse("http://checkvist.com")
    end

    def getCheckLists
      json_call Net::HTTP::Get.new("/checklists.json")
    end

    def json_call request, parameters = nil
      request.basic_auth @email, @api_key if @email
      request.set_form_data(parameters) if parameters
    
      res = Net::HTTP.start(@url.host, @url.port) { |http|
        http.request(request)
      }
    
      case res
      when Net::HTTPSuccess
        JSON.parse(res.body)
      else
        res.error!
      end
    end
    
  end

  class WorkSpace
   WORKSPACE_FILENAME = ".workspace"	  
   def self.clear
     File.delete(WORKSPACE_FILENAME)
   end
   def self.currentList= listName
     File.open(WORKSPACE_FILENAME, 'w') {|f| f.write(listName)}
   end
   def self.isCurrentList? listName

     return nil if !File.exist?(WORKSPACE_FILENAME)

     storedName = File.read(WORKSPACE_FILENAME)
     storedName == listName
   end
  end

  class CheckvistProxyMock

    @@lists = []

    def initialize
      @@lists = []
    end

    def getCheckLists
      @@lists.map {|list| Hash["name" => list] }
    end

    def self.add_list(list_name)
      @@lists << list_name
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

