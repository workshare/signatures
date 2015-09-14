module Signatures
  module Validators
    class Basic
      attr_accessor :keystore, :signer

      def initialize(signer: Signers::Keystore.new(keystore))
        self.signer = signer
      end

      def call(to_validate:, signature:, **args)
        gen_sig = signer.call(to_validate, args)
        gen_sig == signature
      end

      private

      attr_writer :keystore, :signer
    end
  end
end