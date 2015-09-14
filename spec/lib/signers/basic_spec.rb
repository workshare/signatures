require 'spec_helper'

describe Signatures::Signers::Basic do
  subject { described_class.new(hmac: hmac, sha: :sha) }
  let(:hmac) { double hexdigest: true }

  describe '#call' do
    context 'when the text to sign is not a collection' do
      it 'generates a hexdigest' do
        expect(hmac).to receive(:hexdigest).with(:sha, :secret, 'to_sign')
        subject.call :to_sign, secret: :secret
      end
    end

    context 'when the text to sign is a collection' do
      it 'generates a hexdigest of the join of elements in the collection' do
        expect(hmac).to receive(:hexdigest).with(:sha, :secret, 'ab')
        subject.call [:a, :b], secret: :secret
      end
    end
  end
end