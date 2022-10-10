# frozen_string_literal: true

module Faraday
  module Jwt
    class Response < Middleware
      def initialize(app = nil, verification_key: :skip_verification, signing_algs: nil, content_type: 'application/jwt')
        super app
        @verification_key = verification_key
        @signing_algs = signing_algs
        @content_types = Array(content_type)
      end

      def on_complete(env)
        decode_body!(env) if decodable_content?(env)
      end

      private

      def decode_body!(env)
        env[:raw_body] = env[:body]
        env[:body] = JSON::JWT.decode(env[:body], @verification_key, @signing_algs)
      rescue => e
        raise Faraday::ParsingError.new(e, env[:response])
      end

      def decodable_content?(env)
        env[:body].respond_to?(:to_str) && !env[:body].strip.empty? &&
        decodable_content_type?(env[:response_headers])
      end

      def decodable_content_type?(headers)
        @content_types.any? do |content_type|
          content_type_of(headers) == content_type
        end
      end

      def content_type_of(headers)
        type = headers[CONTENT_TYPE].to_s
        type = type.split(';', 2).first if type.index(';')
        type
      end
    end
  end
end

Faraday::Response.register_middleware(jwt: Faraday::JWT::Response)