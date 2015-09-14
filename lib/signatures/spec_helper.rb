module Signatures
  module SpecHelper
    def signer
      Signatrues::Basic
    end

    def secret
      'test_secret'
    end

    def signature_key
      'test'
    end

    def timestamp
      1
    end

    def signed_request!(method = :get, uri = '', params = {}, env = {}, &block)
      to_sign = if method == :get
        params.to_param
      else
        params.to_json
      end

      signature = signer.call to_sign, timestamp, secret: secret
      header 'HTTP_SIGNATURE', signature
      header 'HTTP_TIMESTAMP', timestamp
      header 'HTTP_SIGNATURE_KEY', signature_key
      send method, uri, params, env, &block
    end
  end
end