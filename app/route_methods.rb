# frozen_string_literal: true

module Methods
  def home
    post = Article.all
    if !post.nil?
      @posts = post.sort_by(&:created_at).reverse

      response_body = render_template('home', binding)
      [200, { 'Content-Type' => 'text/html' }, [response_body]]
    else
      [404, { 'Content-Type' => 'application/json' }, ['{ "error": "Not Found" }']]
    end
  end

  def read_article(id)
    @post = Article.read(id.to_i)

    if @post
      response_body = render_template('read_article', binding)
      [200, { 'Content-Type' => 'text/html' }, [response_body]]
    else
      [404, { 'Content-Type' => 'application/json' }, ['{ "error": "Not Found" }']]
    end
  end

  def admin_login
    if @request.post?
      email = @request.params['email']
      password = @request.params['password']

      if Admin.login(email, password)
        @session['admin_logged_in'] = true
        [302, { 'Location' => '/admin/admin_dashboard' }, []]
      else
        [401, { 'Content-Type' => 'text/plain' }, ['Invalid credentials']]
      end
    else
      response_body = render_template('admin_login', binding)
      [201, { 'Content-Type' => 'text/html' }, [response_body]]
    end
  end

  def admin_logout
    @session['admin_logged_in'] = nil
    [302, { 'Location' => '/admin' }, []]
  end

  def admin_dashboard
    post = Article.all
    @posts = post.sort_by(&:created_at).reverse
    response_body = render_template('admin_dashboard', binding)
    [200, { 'Content-Type' => 'text/html' }, [response_body]]
  end

  def admin_create
    if @request.post?
      title = @request.params['title']
      content = @request.params['content']
      article = Article.new(title, content)
      article.create

      [302, { 'Location' => "/admin/admin_dashboard/read_article/#{article.id}" }, []]
    else
      response_body = render_template('create_article', binding)
      [201, { 'Content-Type' => 'text/html' }, [response_body]]
    end
  end

  def admin_read(id)
    @post = Article.read(id.to_i)

    if @post
      response_body = render_template('admin_read_article', binding)
      [200, { 'Content-Type' => 'text/html' }, [response_body]]
    else
      [404, { 'Content-Type' => 'aplication/json' }, ['{ "error": "Not Found" }']]
    end
  end

  def admin_update(id)
    @post = Article.read(id.to_i)
    if @request.post?
      title = @request.params['title']
      content = @request.params['content']

      Article.update(title, content, id)
      [302, { 'Location' => "/admin/admin_dashboard/read_article/#{id}" }, []]
    else
      response_body = render_template('update_article', binding)
      [200, { 'Content-Type' => 'text/html' }, [response_body]]
    end
  end

  def admin_destroy(id)
    Article.destroy(id.to_i)
    [303, { 'Location' => '/admin/admin_dashboard' }, []]
  end
end
