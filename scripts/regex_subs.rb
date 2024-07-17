file_path = 'app/app.rb'
content = File.read(file_path)

replaced_word = content.gsub(/(redator|Redator)/) do |match|
  match == 'Redator' ? 'Article' : 'article'
end

File.open(file_path, 'w') { |file| file.write(replaced_word) }
