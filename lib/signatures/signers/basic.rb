require 'openssl'

module Signatures
  module Signers
    class Basic
      attr_reader :hmac, :sha

      def initialize(hmac: OpenSSL::HMAC, sha: OpenSSL::Digest::SHA1.new)
        self.hmac = hmac
        self.sha = sha
      end

      def call(to_sign, secret:, **options)
        text_to_sign = Array(to_sign).map(&:to_s).join
        hmac.hexdigest sha, secret, text_to_sign
      end

      private

      attr_writer :hmac, :sha
    end
  end
end
