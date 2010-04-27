Given /^I have to mock up a proxy for Checkvist$/ do
  proxy = Jot::CheckvistProxyMock.new

  Jot::ListProviderFactory.should_receive(:getProvider).and_return(Jot::CheckvistListProvider.new(proxy))

end

Given /^I have an existing list with:$/ do |table|

  table.hashes.each {|hash| Jot::CheckvistProxyMock.add_list hash[:name] }

end

Given /^I have an existing list called "([^\"]*)" list$/ do |list_name|

  Jot::CheckvistProxyMock.add_list(list_name)

end

Given /^jot knows "([^\"]*)" is the current list$/ do |list_name|
  Jot::WorkSpace.currentList = list_name
end

Given /^none of the lists are marked as current$/ do
  Jot::WorkSpace.clear
end

When /^I ask to see the lists$/ do
  @output = StringIO.new
  jot = Jot::Jot.new(@output)
  jot.show_lists
end

When /^I ask to make "([^\"]*)" the current list$/ do |list_name|
  @output = StringIO.new
  jot = Jot::Jot.new(@output)
  jot.changeCurrentListTo list_name
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
    Jot::WorkSpace.isCurrentList?(line.slice(3, line.length-3)) 
  }
  listNames.length.should == 1
end

Then /^the jot workspace should have the "([^\"]*)" list marked as current$/ do
|list_name|
  lines = @output.string.split("\n")
  listNames = lines.select {|line| 
    Jot::WorkSpace.isCurrentList?(line.slice(3, line.length-3)) 
  }
  listNames[0].should =~ Regexp.new(list_name)
end


