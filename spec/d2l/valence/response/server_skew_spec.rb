require 'spec_helper'

describe D2L::Valence::Response, type: :service do
  Struct.new('DummyHttpResponse', :code, :body)

  context '.server_skew' do
    subject { described_class.new(http_response) }
    let(:http_response) { Struct::DummyHttpResponse.new(code, body) }

    context 'with bad timestamp' do
      let(:code) { 403 }
      let(:server_time_in_seconds) { (Time.now.to_f).to_i + time_skew }
      let(:time_skew) { 60 * 60 }
      let(:body) { "Timestamp out of range #{server_time_in_seconds}" }

      its(:server_skew) { is_expected.to_not eq 0 }
    end

    context 'with invalid token' do
      let(:code) { 403 }
      let(:body) { 'invalid token'}

      its(:server_skew) { is_expected.to eq 0 }
    end

    context 'with a successful request' do
      let(:code) { 200 }
      let(:body) { 'success'}

      its(:server_skew) { is_expected.to eq 0 }
    end
  end
end
