Given /^the current list has the following tasks:$/ do |table|
  tasks = table.hashes
  task_array = tasks.map {|task| build_json_task task}
  json = "[#{task_array * ","}]"
  
  FakeWeb.register_uri(:get, "http://#{escape(@user)}:#{escape(@password)}@checkvist.com/checklists/12/tasks.json", :body => json)
end

When /^I ask to see the tasks for the current list$/ do
  jot = Jot::Cli::Main.new([], @output)
end

