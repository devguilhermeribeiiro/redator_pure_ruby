require 'rack'
require 'erb'
require_relative 'redator'
require_relative 'database'

class App
  def call(env)
    request = Rack::Request.new(env)

    case request.path
    when '/'
      @posts = Redator.all

      template = File.read('views/get_all_articles.html.erb')
      renderer = ERB.new(template)

      response_body = renderer.result(binding)

      [200, {'Content-Type' => 'text/html'}, [response_body]]

    when '/create'
      if request.post?
        title = request.params['title']
        content = request.params['content']

        redator = Redator.new(title, content)
        redator.create

        [302, {'Location' => "/read/#{redator.id}"}, ['{"success": "Article created"}']]
      else
        template = File.read("views/create_article.html.erb")
        renderer = ERB.new(template)

        response_body = renderer.result(binding)
        [201, {'Content-Type' => 'text/html'}, [response_body]]
      end

    when %r{^/read/(\d+)$} #regex for /read/:id
      id = $1.to_i
      @post = Redator.read(id)

      if @post
        template = File.read('views/read_article.html.erb')
        renderer = ERB.new(template)
        response_body = renderer.result(binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      else
        [404, {'Content-Type' => 'aplication/json'}, ['{"error": "Not Found"}']]
      end

    when %r{^/update/(\d+)$} #regex for /update/:id
      id = $1.to_i
      @post = Redator.read(id)
      if request.post?
        title = request.params['title']
        content = request.params['content']

        Redator.update(title, content, id)
        [302, {'Location' => "/read/#{id}"}, ['{"success": "Article updated"}'] ]
      else
        template = File.read("views/update_article.html.erb")
        renderer = ERB.new(template)

        response_body = renderer.result(binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      end

    when %r{^/destroy/(\d+)$} #regex for /destroy/:id
      id = $1.to_i
      Redator.destroy(id)
      [303, {'Location' => '/'}, ['{"success": "Article destroyed"}']]
    else
      [404, {'Content-Type' => 'application/json'}, ['{"error": "Not Found"}']]
    end
  end
end
