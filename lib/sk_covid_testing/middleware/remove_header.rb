module SkCovidTesting
  module Middleware
    class RemoveHeader
      attr_reader :headers_to_remove

      def initialize(app, headers: [])
        @app = app
        @headers_to_remove = headers
      end

      def call(env)
        r = @app.call(env)
        headers = r[1]

        headers_to_remove.map do |header|
          headers.delete header
        end

        r
      end
    end
  end
end