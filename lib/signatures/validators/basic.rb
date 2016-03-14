module Signatures
  module Validators
    class Basic
      attr_accessor :keystore, :signer, :expiration_time, :clock

      def initialize(keystore: {}, signer: Signers::Keystore.new(keystore: keystore), expiration_time: 900, clock: Time)
        self.signer = signer
        self.expiration_time = expiration_time
        self.clock = clock
      end

      def call(to_validate:, signature:, key:, timestamp: nil)
        !expired_signature?(timestamp) &&
        signer.call(to_validate, key: key, timestamp: timestamp) == signature
      end

      private

      def expired_signature?(timestamp)
        timestamp && (clock.now.to_i - timestamp) > expiration_time
      end

      attr_writer :keystore, :signer, :expiration_time, :clock
    end
  end
end