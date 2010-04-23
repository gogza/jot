Given /^I have to mock up a proxy for Checkvist$/ do
  proxy = Jot::CheckvistProxyMock.new

  Jot::ListProviderFactory.should_receive(:getProvider).and_return(Jot::CheckvistListProvider.new(proxy))

end


Given /^I have an existing list called "([^\"]*)" list$/ do |list_name|

  Jot::CheckvistProxyMock.add_list(list_name)

end

Given /^jot knows "([^\"]*)" is the current list$/ do |list_name|
  Jot::WorkSpace.currentList = list_name
end

When /^I ask to see the lists$/ do
  @output = StringIO.new
  jot = Jot::Jot.new(@output)
  jot.show_lists
end

Then /^jot should show the "([^\"]*)" list$/ do |list_name|
  items_matching_list_name = @output.string.split("\n").select {|list| list =~ Regexp.new(list_name)}
  items_matching_list_name.length.should == 1
end

Then /^jot should mark the "([^\"]*)" as current$/ do |list_name|
  lines = @output.string.split("\n")
  list_displayed = lines.select {|line| line.include?(list_name) }
  list_displayed[0].should =~ /^ * /
end

Then /^jot should not mark the "([^\"]*)" as current$/ do |list_name|
  lines = @output.string.split("\n")
  list_displayed = lines.select {|line| line.include?(list_name) }
  list_displayed[0].should =~ /^   /
end

