Given /^I have to mock up a proxy for Checkvist$/ do

  Given "I have a configuration file containing:", table(%{
     | email          | api        |
     | joe@bloggs.com | ABC1234567 |
  })

  @output = StringIO.new
  @workspace = Jot::WorkSpace.new(Jot::CheckvistProxyMock, @output)

  Jot::Cli::Main.should_receive(:create_workspace).and_return(@workspace)

end

Given /^I have an existing list with:$/ do |table|

  table.hashes.each {|hash| Jot::CheckvistProxyMock.add_list hash[:name] }

end

Given /^I have an existing list called "([^\"]*)" list$/ do |list_name|

  Jot::CheckvistProxyMock.add_list(list_name)

end

Given /^jot knows "([^\"]*)" is the current list$/ do |list_name|
  @workspace.currentList = list_name
end

Given /^none of the lists are marked as current$/ do
  @workspace.clear
end

Given /^I have a configuration file containing:$/ do |table|
  config_hash = table.hashes.first

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
  lines = @output.string.split("\n")
  listNames = lines.select {|line| 
    @workspace.isCurrentList?(line.slice(3, line.length-3)) 
  }
  listNames.length.should == 1
end

Then /^the jot workspace should have the "([^\"]*)" list marked as current$/ do
|list_name|
  lines = @output.string.split("\n")
  listNames = lines.select {|line| 
    @workspace.isCurrentList?(line.slice(3, line.length-3)) 
  }
  listNames[0].should =~ Regexp.new(list_name)
end

Then /^jot should display a message saying "([^\"]*)"$/ do |message|
  puts "!!! " + @output.string
  @output.string.should =~ Regexp.new(message)
end

Then /^jot should display the following:$/ do |table|
  table.hashes.each{|hash| Then "jot should display a message saying \"#{hash[:displayed]}\""}
end

Then /^the configuration file should contain the following:$/ do |table|
  table.hashes.each{|hash| File.read("jot.config").should =~ Regexp.new(hash["value"])}	
end



