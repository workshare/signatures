module Signatures
  module Validators
    class Basic
      attr_accessor :keystore, :signer, :expiration_time, :clock

      def initialize(keystore: {}, signer: Signers::Keystore.new(keystore: keystore), expiration_time: 900, clock: Time)
        self.signer = signer
        self.expiration_time = expiration_time
        self.clock = clock
      end

      def call(to_validate:, signature:, **args)
        !expired_signature?(to_validate) &&
        signer.call(to_validate, args) == signature
      end

      private

      def expired_signature?(signature_params)
        signature_params[:timestamp] &&
        (clock.now.to_i - signature_params[:timestamp]) > expiration_time
      end

      attr_writer :keystore, :signer, :expiration_time, :clock
    end
  end
end