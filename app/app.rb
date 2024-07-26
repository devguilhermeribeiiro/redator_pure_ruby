require 'rack'
require 'erb'
require_relative 'article'
require_relative 'database'
require_relative 'customers'
require_relative 'admin'
require_relative 'route_methods'

class App
  include Methods

  def call(env)
    @request = Rack::Request.new(env)

    case @request.path
    when '/'
      home
    when %r{^/read/(\d+)$}
      read_article(::Regexp.last_match(1))
    when '/admin'
      admin_login
    when '/admin/admin_dashboard'
      admin_dashboard
    when '/admin/admin_dashboard/create_article'
      admin_create
    when %r{^/admin/admin_dashboard/read_article/(\d+)$}
      admin_read(::Regexp.last_match(1))
    when %r{^/admin/admin_dashboard/update_article/(\d+)$}
      admin_update(::Regexp.last_match(1))
    when %r{^/admin/admin_dashboard/destroy_article/(\d+)$}
      admin_destroy(::Regexp.last_match(1))
    else
      [404, { 'Content-Type' => 'application/json' }, ['{"error": "Not Found"}']]
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
    [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']]
  end
end
