file_path = 'app/route_methods.rb'
content = File.read(file_path)

# Regex para adicionar espaços ao início e ao final das chaves
replaced_content = content.gsub(/(\{)([^{}]*)(\})/) do
  "{ #{$2.strip} }"
end

# Escreva o conteúdo atualizado de volta para o arquivo
File.open(file_path, 'w') { |file| file.write(replaced_content) }
