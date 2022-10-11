# frozen_string_literal: true

module Faraday
  module JWT
    class Request < Middleware
      def initialize(app = nil, signing_key: nil, signing_alg: :autodetect, content_type: 'application/jwt')
        super app
        @signing_key = signing_key
        @signing_alg = signing_alg
        @content_types = Array(content_type)
      end

      def on_request(env)
        encode_body!(env) if encodable_content?(env)
      end

      private

      def encode_body!(env)
        jwt = JSON::JWT.new env[:body]
        env[:body] = if @signing_key.present?
          jwt.sign @signing_key, @signing_alg
        else
          jwt
        end.to_s
      end

      def encodable_content?(env)
        !env[:body].respond_to?(:to_str) &&
        encodable_content_type?(env[:request_headers])
      end

      def encodable_content_type?(headers)
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

Faraday::Request.register_middleware(jwt: Faraday::JWT::Request)