class ResponseTimer
  def initialize(app)
    @app = app
  end

  def call(env)
    status, header, response = @app.call(env)
    [200, {"Content-Type" => "text/html"}, ["Hello World!!" + response.body]]
  end
end