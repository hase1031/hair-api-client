require "hair/api/client/version"
require 'net/http'
require 'json'

module Hair
  module Api

    class RequestError < StandardError;
    end

    module Client

      API_ENDPOINT = 'https://api.hair.cm'

      @@options = {}

      # Default search options
      def self.options
        @@options
      end

      # Set default search options
      def self.options=(opts)
        @@options = opts
      end

      def self.configure(&proc)
        fail ArgumentError, "Block is required." unless block_given?
        yield @@options
      end

      def self.image_search(query, opts = {})
        opts[:path] = '/image/search'
        opts[:query] = query
        self.send_request(opts)
      end

      def self.send_request(opts)
        opts = self.options.merge(opts) if self.options
        request_url = prepare_url(opts)
        http_response = Net::HTTP.get_response(URI::parse(request_url))
        res = Response.new(http_response.body)
        unless http_response.kind_of? Net::HTTPSuccess
          err_msg = "HTTP Response: #{http_response.code} #{http_response.message}"
          err_msg += " - #{res.error}" if res.error
          fail Hair::Api::RequestError, err_msg
        end
        res
      end

      class Response

        def initialize(json)
          @body = JSON.parse(json)
        end

        def body
          @body
        end

        def error
          @body['message']
        end

        def error_code
          @body['status']
        end

        def images
          @body['data']
        end

      end

      private

      def self.prepare_url(opts)
        path = opts.delete(:path)
        API_ENDPOINT + path + '?' + URI.encode_www_form(opts)
      end

    end
  end
end
