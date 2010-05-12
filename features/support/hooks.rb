CONFIG_FILENAME = "jot.config"
BACKUP_FILENAME = "." + CONFIG_FILENAME

Before('@config') do
  puts "Hiding the current config file"
  File.delete(BACKUP_FILENAME) if File.exist?(BACKUP_FILENAME)
  File.copy(CONFIG_FILENAME, BACKUP_FILENAME)
  File.delete(CONFIG_FILENAME)
end

After('@config') do
  puts "Restoring the current config file"
  File.delete(CONFIG_FILENAME) if File.exist?(CONFIG_FILENAME) 
  File.copy(BACKUP_FILENAME, CONFIG_FILENAME)
  File.delete(BACKUP_FILENAME)  
end

