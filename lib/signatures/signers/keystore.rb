module Signatures
  module Signers
    class Keystore
      attr_reader :keystore, :base_signer

      def initialize(keystore:, base_signer: Basic.new, **opts)
        self.keystore = keystore
        self.base_signer = base_signer
      end

      def call(to_sign, key:, **options)
        base_signer.call to_sign, options.merge(secret: keystore[key])
      end

      private

      attr_accessor :keystore, :base_signer
    end
  end
end
