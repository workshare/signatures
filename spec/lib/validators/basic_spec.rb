require 'spec_helper'

describe Signatures::Validators::Basic do
  subject { described_class.new signer: signer }
  let(:signer) { double call: true }

  describe '#call' do
    before do
      allow(signer).to receive(:call)
        .with(:to_validate, key: :key).and_return(signed)
    end

    context 'when the signature for the given text is the same as the signature received' do
      let(:signed) { :signature }

      it 'returns true' do
        expect(subject.call(to_validate: :to_validate, signature: :signature, key: :key)).to be true
      end
    end

    context 'when the signature for the given text is not the same as the signature received' do
      let(:signed) { :something }

      it 'returns false' do
        expect(subject.call(to_validate: :to_validate, signature: :signature, key: :key)).to be false
      end
    end
  end
end