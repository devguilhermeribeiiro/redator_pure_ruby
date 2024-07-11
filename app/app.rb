require 'rack'
require 'erb'
require_relative 'redator'
require_relative 'database'

class App
  ADM_USERNAME = '@oliverriver'
  ADM_PASSWORD = '@oliverriver'

  def call(env)
    request = Rack::Request.new(env)

    case request.path
    when '/'
      @posts = Redator.all

      response_body = render_template('home', binding)
      [200, {'Content-Type' => 'text/html'}, [response_body]]

    when %r{^/read/(\d+)$} #regex for /read/:id
      id = $1.to_i
      @post = Redator.read(id)

      if @post
        response_body = render_template('read_article', binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      else
        [404, {'Content-Type' => 'application/json'}, ['{"error": "Not Found"}']]
      end

    when '/admin'
      if is_auth?(request)
        response_body = render_template('admin_dashboard', binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      else
        un_auth_response
      end

    when '/admin/create'
      if request.post?
        title = request.params['title']
        content = request.params['content']

        redator = Redator.new(title, content)
        redator.create

        [302, {'Location' => "/admin/read/#{redator.id}"}, []]
      else
        response_body = render_template('create_article', binding)
        [201, {'Content-Type' => 'text/html'}, [response_body]]
      end

    when %r{^/admin/read/(\d+)$} #regex for /admin/read/:id
      id = $1.to_i
      @post = Redator.read(id)

      if @post
        response_body = render_template('admin_read_article', binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      else
        [404, {'Content-Type' => 'aplication/json'}, ['{"error": "Not Found"}']]
      end

    when %r{^/admin/update/(\d+)$} #regex for admin/update/:id
      id = $1.to_i
      @post = Redator.read(id)
      if request.post?
        title = request.params['title']
        content = request.params['content']

        Redator.update(title, content, id)
        [302, {'Location' => "/read/#{id}"}, [] ]
      else
        response_body = render_template('update_article', binding)
        [200, {'Content-Type' => 'text/html'}, [response_body]]
      end

    when %r{^/admin/destroy/(\d+)$} #regex for /admin/destroy/:id
      id = $1.to_i
      Redator.destroy(id)
      [303, {'Location' => '/'}, []]
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

  def is_auth?(request)
    auth = Rack::Auth::Basic::Request.new(request.env)
    auth.provided? && auth.basic? && auth.credentials && auth.credentials == [App::ADM_USERNAME, App::ADM_PASSWORD]
  end

  def un_auth_response
    [401, {'Content-Type' => 'text/plain', 'WWW-Authenticate' => 'Basic reaml="Restricted Area"'}, ['Unauthorized']]
  end
end
