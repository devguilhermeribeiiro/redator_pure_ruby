# frozen_string_literal: true

require 'rack'
require 'erb'
require_relative 'database'
require_relative 'admin'
require_relative 'article'
require_relative 'route_methods'
require_relative '../scripts/db_migrate/migrate.rb'

class App
  include Methods

  def call(env)
    @request = Rack::Request.new(env)
    @session = @request.session

    case @request.path
    when '/'
      home
    when %r{^/read/(\d+)$}
      read_article(::Regexp.last_match(1))
    when '/admin'
      admin_login
    when '/admin/admin_dashboard'
      if authenticated?
        admin_dashboard
      else
        [302, { 'location' => '/admin' }, []]
      end
    when '/admin/admin_dashboard/create_article'
      if authenticated?
        admin_create
      else
        [302, { 'location' => '/admin' }, []]
      end
    when %r{^/admin/admin_dashboard/read_article/(\d+)$}
      if authenticated?
        admin_read(::Regexp.last_match(1))
      else
        [302, { 'location' => '/admin' }, []]
      end
    when %r{^/admin/admin_dashboard/update_article/(\d+)$}
      if authenticated?
        admin_update(::Regexp.last_match(1))
      else
        [302, { 'location' => '/admin' }, []]
      end
    when %r{^/admin/admin_dashboard/destroy_article/(\d+)$}
      if authenticated?
        admin_destroy(::Regexp.last_match(1))
      else
        [302, { 'location' => '/admin' }, []]
      end
    when '/admin/logout'
      admin_logout
    else
      [404, { 'content-type' => 'application/json' }, ['{"error": "Not Found"}']]
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

  def authenticated?
    @session['admin_logged_in']
  end
end
