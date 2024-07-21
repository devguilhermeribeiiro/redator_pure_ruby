require 'rack'
require 'erb'
require_relative 'article'
require_relative 'database'
require_relative 'customers'
require_relative 'admin'

class App

  def call(env)
    request = Rack::Request.new(env)

    case request.path
    when '/'
      @posts = Article.all

      response_body = render_template('home', binding)
      [200, {'Content-Type' => 'text/html'}, [response_body]]

    when %r{^/read/(\d+)$} #regex for /read/:id
      id = $1.to_i
      @post = Article.read(id)

      if @post
        response_body = render_template('read_article', binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      else
        [404, {'Content-Type' => 'application/json'}, ['{"error": "Not Found"}']]
      end

    when '/admin'

      if request.post?
        email = request.params['email']
        password = request.params['password']

        login = Admin.login(email, password)

        if login
          response_body = render_template('admin_dashboard', binding)
          [200, {'Content-Type' => 'text/html'}, [response_body]]
        else
          un_auth_response
        end
      else
        response_body = render_template('admin_login', binding)
        [201, {'Content-Type' => 'text/html'}, [response_body]]
      end

    when '/admin/create_article'
      if request.post?
        title = request.params['title']
        content = request.params['content']

        article = Article.new(title, content)
        article.create

        [302, {'Location' => "/admin/read_article/#{article.id}"}, []]
      else
        response_body = render_template('create_article', binding)
        [201, {'Content-Type' => 'text/html'}, [response_body]]
      end

    when %r{^/admin/read_article/(\d+)$} #regex for /admin/read/:id
      id = $1.to_i
      @post = Article.read(id)

      if @post
        response_body = render_template('admin_read_article', binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      else
        [404, {'Content-Type' => 'aplication/json'}, ['{"error": "Not Found"}']]
      end

    when %r{^/admin/update_article/(\d+)$} #regex for admin/update/:id
      id = $1.to_i
      @post = Article.read(id)
      if request.post?
        title = request.params['title']
        content = request.params['content']

        Article.update(title, content, id)
        [302, {'Location' => "/admin/read_article/#{id}"}, [] ]
      else
        response_body = render_template('update_article', binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      end

    when %r{^/admin/destroy_article/(\d+)$} #regex for /admin/destroy/:id
      id = $1.to_i
      Article.destroy(id)
      [303, {'Location' => '/admin'}, []]
    else
      [404, {'Content-Type' => 'application/json'}, ['{"error": "Not Found"}']]
    end
  end

  private

  def render_template(template_name, binding)
    template_path = "views/#{template_name}.html.erb"

    # unless File.exist?(template_path)
    #   default_content = "<!-- Default content for #{template_name} -->"
    #   File.write(template_path, default_content)
    # end

    template = File.read(template_path)
    ERB.new(template).result(binding)
  end

  def un_auth_response
    [401, {'Content-Type' => 'text/plain'}, ['Unauthorized']]
  end
end
