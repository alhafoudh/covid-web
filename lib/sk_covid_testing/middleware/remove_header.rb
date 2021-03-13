module SkCovidTesting
  module Middleware
    class RemoveHeader
      attr_reader :headers_mapping

      def initialize(app, headers: [])
        @app = app
        @headers_mapping = headers
      end

      def call(env)
        r = @app.call(env)
        headers = r[1]

        headers_mapping.map do |header_mapping|
          header = header_mapping[:name]

          if header_mapping.has_key?(:rename_to)
            rename_to = header_mapping[:rename_to]

            headers[rename_to] = headers[header]
            headers.delete header
          else
            headers.delete header
          end
        end

        r
      end
    end
  end
end