module Middlewares
  class SetTimeZone
    def initialize(app)
      @app = app
    end

    def call(env)
      Time.zone = 'Kyiv'

      @app.call(env)
    end
  end
end
