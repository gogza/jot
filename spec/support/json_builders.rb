def build_hash_tasks tasks
  tasks.map {|task| Hash["id" => task[0], "content" => task[1], "parent_id" => task[2], "children" => "[#{task[3]}]"]}
end

def build_json_lists lists

  json_array = lists.map {|list| build_json list}
  
  return "[#{json_array * ","}]"
 
end

def build_json_tasks tasks

  json_array = tasks.map {|task| build_json_task task}
  
  return "[#{json_array * ","}]"

end

def build_json list
  "{\"name\":\"#{list["name"]}\",\"updated_at\":\"2010/04/19 18:45:22 +0000\",\"public\":true,\"id\":#{list["id"]},\"task_completed\":0,\"task_count\":2}"
end

def build_json_task task
  "{\"status\":0,\"collapsed\":false,\"updated_at\":\"\",\"details\":{},\"checklist_id\":32456,\"update_line\":\"\",\"id\":#{task["id"]},\"tasks\":[#{task["children"]}],\"content\":\"#{task["content"]}\",\"comments_count\":0,\"due\":null,\"position\":1,\"parent_id\":#{task["parent"]}}"
end


