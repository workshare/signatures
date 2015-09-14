require 'spec_helper'

describe Signatures::Signers::Keystore do
  subject { described_class.new(keystore: keystore, base_signer: base_signer) }
  let(:keystore) { { key_1: :secret_1 } }
  let(:base_signer) { double 'signer', call: true }

  describe '#call' do
    it 'calls the base signer with a secret extracted from the keystore for the given key' do
      expect(base_signer).to receive(:call).with(:text_to_sign, secret: :secret_1, other_opt: :some)
      subject.call(:text_to_sign, key: :key_1, other_opt: :some)
    end
  end
end