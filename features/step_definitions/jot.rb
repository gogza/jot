Given /^I want to output to a string$/ do

  @output = StringIO.new
  FakeWeb.allow_net_connect = false
  FakeWeb.clean_registry

end

Given /^Checkvist has the existing lists:$/ do |table|

  @lists = table.hashes

  json = build_json_lists @lists
 
  FakeWeb.register_uri(:get, "http://#{escape(@user)}:#{escape(@password)}@checkvist.com/checklists.json", :body => json)

end

def escape parameter
  URI.escape(parameter, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) 
end

Given /^jot knows "([^\"]*)" is the current list$/ do |list_name|
  list_id = get_list_id_from_name list_name
  File.open(STATE_FILENAME,'w') {|f| f.write({"currentListId" => list_id}.to_yaml)}
end

def get_list_id_from_name list_name
  (@lists.select {|list| list["name"] == list_name } ).first["id"]
end


Given /^none of the lists are marked as current$/ do
  File.open(STATE_FILENAME,'w') {|f| f.write Hash["currentListId" => nil].to_yaml}
end

Given /^I have a configuration file containing:$/ do |table|
  config_hash = table.hashes.first

  @user = config_hash["email"]
  @password = config_hash["api"]

  config_file_name = "jot.config"

  File.delete(config_file_name) if File.exist?(config_file_name)
  
  File.open(config_file_name,'w') {|f| f.write(config_hash.to_yaml)}

end

When /^I ask to see the lists$/ do
  jot = Jot::Cli::Main.new(["lists"], @output)
end

When /^I ask to make "([^\"]*)" the current list$/ do |list_name|
  jot = Jot::Cli::Main.new(["lists", list_name], @output)
end

When /^I ask to see the configuration$/ do
  jot = Jot::Cli::Main.new(["config"], @output)
end

When /^I ask to change the configuration to:$/ do |table|
  config = table.hashes.first
  jot = Jot::Cli::Main.new(["config", "-e", config["email"], "-a", config["api"]], @output)  
end

Then /^jot should display the following lists:$/ do |table|
  table.hashes.each{|hash| Then "jot should show the \"#{hash[:name]}\" list"}
end

Then /^jot should show the "([^\"]*)" list$/ do |list_name|
  items_matching_list_name = @output.string.split("\n").select {|list| list =~ Regexp.new(list_name)}
  items_matching_list_name.length.should == 1
end

Then /^jot should mark the "([^\"]*)" as current$/ do |list_name|
  lines = @output.string.split("\n")
  list_displayed = lines.select {|line| line.include?(list_name) }
  list_displayed[0].should =~ /^ \* /
end

Then /^jot should not mark the "([^\"]*)" as current$/ do |list_name|
  lines = @output.string.split("\n")
  list_displayed = lines.select {|line| line.include?(list_name) }
  list_displayed[0].should =~ /^   /
end

Then /^jot should mark the one of the lists as current$/ do
  lines = @output.string.split("\n")
  currentLines = lines.select {|line| line =~ /^ \* /}
  currentLines.length.should == 1  
end

Then /^the jot workspace should have one list marked as current$/ do
  File.read(STATE_FILENAME).length.should_not == 0
end

Then /^the jot workspace should have the "([^\"]*)" list marked as current$/ do
|list_name|
  list_id = get_list_id_from_name list_name
  File.read(STATE_FILENAME).should =~ Regexp.new(list_id.to_s)
end

Then /^jot should display a message saying "([^\"]*)"$/ do |message|
  Then "jot should display this phrase \"#{message}\""
end

Then /^jot should display the following:$/ do |table|
  table.hashes.each{|hash| Then "jot should display this phrase \"#{hash[:displayed]}\""}
end

Then /^the configuration file should contain the following:$/ do |table|
  table.hashes.each{|hash| File.read("jot.config").should =~ Regexp.new(hash["value"])}	
end

Then /^jot should display this phrase "([^\"]*)"$/ do |message|
  @output.string.should =~ Regexp.new(message)
end


