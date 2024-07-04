require 'rack'
require 'erb'
require_relative 'redator'
require_relative 'database'

class App

  def call(env)
    request = Rack::Request.new(env)

    case request.path

    when '/'
      @posts = Redator.read

      template = File.read('get_all_articles.html.erb')
      renderer = ERB.new(template)

      response_body = renderer.result(binding)

      [200, {'Content-Type': 'text/html' }, [response_body]]
    when '/create'
      if request.post?
        title = request.params['title']
        content = request.params['content']

        redator = Redator.new(title, content)
        redator.create

        [302, {'Location': '/'}, []]
      else
        template = File.read("create_article.html.erb")
        renderer = ERB.new(template)

        response_body = renderer.result(binding)
        [200, {'Content-Type': 'text/html'}, [response_body]]
      end
    else
      [404, {'Content-Type': 'application/json'}, ['{"error": "Not Found"}']]
    end
  end
end
