
def hide_file filename, backup_filename
  File.delete(backup_filename) if File.exist?(backup_filename)
  File.copy(filename, backup_filename)
  File.delete(filename)
end

Before do
  puts "Hiding the current config and state files"

  hide_file CONFIG_FILENAME, CONFIG_BACKUP_FILENAME
  hide_file STATE_FILENAME, STATE_BACKUP_FILENAME
end

After do
  puts "Restoring the current config and state files"

  hide_file CONFIG_BACKUP_FILENAME, CONFIG_FILENAME
  hide_file STATE_BACKUP_FILENAME, STATE_FILENAME
end

