require "hair/api/client/version"
require 'net/http'
require 'json'

module Hair
  module Api

    class RequestError < StandardError;
    end

    module Client

      API_ENDPOINT = 'https://api.hair.cm'

      @@options = {
          method: 'get'
      }

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

      # Search image by query
      def self.image_search(query, opts = {})
        opts[:path] = '/image/search'
        opts[:query] = query
        self.send_request(opts)
      end

      # Record status of use
      # key is 10 characters, published_at is Time object.
      def self.record(key, title, url, published_at, opts = {})
        opts[:method] = 'post'
        opts[:path] = '/record'
        opts[:image_key] = key
        opts[:entry_title] = title
        opts[:entry_url] = url
        opts[:approve_date] = published_at.strftime('%Y-%m-%d')
        self.send_request(opts)
      end

      def self.send_request(opts)
        opts = self.options.merge(opts) if self.options
        http_response = call_api(opts)
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

      def self.call_api(opts)
        http_method = opts.delete(:method)
        if http_method == 'post'
          request_url = prepare_url({path: opts.delete(:path)})
          Net::HTTP.post_form(URI::parse(request_url), opts)
        else
          request_url = prepare_url(opts)
          Net::HTTP.get_response(URI::parse(request_url))
        end
      end

      def self.prepare_url(opts)
        path = opts.delete(:path)
        query_string = opts.empty? ? '' : '?' + URI.encode_www_form(opts)
        API_ENDPOINT + path + query_string
      end

    end
  end
end
