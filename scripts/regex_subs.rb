file_path = 'app/app.rb'
content = File.read(file_path)

replaced_word = content.gsub('/admin/', '/admin/admin_dashboard/')

File.open(file_path, 'w') { |file| file.write(replaced_word) }
