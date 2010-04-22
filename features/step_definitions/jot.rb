Given /^I have to mock up a proxy for Checkvist$/ do
  proxy = Jot::CheckvistProxyMock.new

  Jot::ListProviderFactory.should_receive(:getProvider).and_return(Jot::CheckvistListProvider.new(proxy))

end


Given /^I have an existing list called "([^\"]*)" list$/ do |list_name|

  Jot::CheckvistProxyMock.add_list(list_name)

end

When /^I ask to see the lists$/ do
  @output = StringIO.new
  jot = Jot::Jot.new(@output)
  jot.show_lists
end

Then /^jot should show the "([^\"]*)" list$/ do |list_name|
  @output.string.split("\n").should include(list_name)
end

