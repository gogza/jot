Given /^the current list has the following tasks "([^\"]*)"$/ do |task_name|
  tasks = build_json_tasks(task_name)
  
  FakeWeb.register_uri(:get, "http://#{escape(@user)}:#{escape(@password)}@checkvist.com/checklists/12/tasks.json", :body => tasks)
end

def build_json_tasks(task_name)
  "[{\"status\":0,\"collapsed\":false,\"updated_at\":\"\",\"details\":{},\"checklist_id\":32456,\"update_line\":\"\",\"id\":1145213,\"tasks\":[1145214,1145215,1145221,1145223],\"content\":\"#{task_name}\",\"comments_count\":0,\"due\":null,\"position\":1,\"parent_id\":0}]"

end

When /^I ask to see the tasks for the current list$/ do
  jot = Jot::Cli::Main.new([], @output)
end

