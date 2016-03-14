require 'rack'
require 'signatures/signers/basic'

module Signatures
  module SpecHelper
    def signer
      Signatures::Signers::Basic.new
    end

    def secret
      'test_secret'
    end

    def signature_key
      'test'
    end

    def timestamp
      9999999999999999999
    end

    def signed_request!(method = :get, uri = '', params = {}, env = {}, &block)
      to_sign = if method == :get
        Rack::Utils.build_query(params)
      else
        params.is_a?(Hash) ? params.to_json : params
      end

      uri = "/#{uri}" if uri[0] != "/"

      signature = signer.call to_sign + uri + timestamp.to_s, secret: secret
      header 'SIGNATURE', signature
      header 'TIMESTAMP', timestamp
      header 'SIGNATURE_KEY', signature_key
      send method, uri, params, env, &block
    end
  end
end