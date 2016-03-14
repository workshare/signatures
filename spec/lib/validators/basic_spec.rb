require 'spec_helper'

describe Signatures::Validators::Basic do
  subject { described_class.new signer: signer, expiration_time: expiration_time, clock: clock }
  let(:signer) { double call: true }
  let(:expiration_time) { 10 }
  let(:clock) { double 'clock', now: time_now }
  let(:time_now) { double :time_now, to_i: (timestamp + time_now_from_timestamp) }
  let(:time_now_from_timestamp) { 5 }
  let(:timestamp) { 100 }

  describe '#call' do
    before do
      allow(signer).to receive(:call)
        .with(to_validate, key: :key, timestamp: timestamp).and_return(signed)
    end

    def do_call
      subject.call(to_validate: to_validate, signature: :signature, key: :key, timestamp: timestamp)
    end

    context 'when there is no timestamp in the signature' do
      let(:to_validate) { :to_validate }

      context 'when the signature for the given text is the same as the signature received' do
        let(:signed) { :signature }

        it 'returns true' do
          expect(do_call).to be true
        end
      end

      context 'when the signature for the given text is not the same as the signature received' do
        let(:signed) { :something }

        it 'returns false' do
          expect(do_call).to be false
        end
      end
    end

    context 'when there is timestamp in the signature' do
      let(:to_validate) { :to_validate }
      let(:time_now_from_timestamp) { 5 }
      let(:signed) { :signature }

      context 'when it is expired' do
        let(:expiration_time) { 2 }

        it 'returns false' do
          expect(do_call).to be false
        end
      end

      context 'when it is not expired' do
        let(:expiration_time) { 10 }

        it 'returns true' do
          expect(do_call).to be true
        end
      end
    end
  end
end