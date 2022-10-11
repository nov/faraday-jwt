# frozen_string_literal: true

RSpec.describe Faraday::JWT::Request do
  let(:faraday) do
    Faraday.new do |conn|
      conn.request :jwt, **options
      conn.adapter :test do |stub|
        stub.post('/') do |env|
          [200, { 'Content-Type' => env[:request_headers]['Content-Type'] }, env[:body]]
        end
      end
    end
  end
  let(:options) { {} }
  let(:request) { faraday.post('/', body, 'Content-Type': content_type) }

  shared_examples :pass_through_content_type do
    describe 'Content-Type' do
      it do
        expect(request.headers['Content-Type']).to eq content_type
      end
    end
  end

  shared_examples :pass_through_request do
    it_behaves_like :pass_through_content_type

    describe 'body' do
      it do
        expect(request.body).to eq body || ''
      end
    end
  end

  shared_examples :encode_body do
    it_behaves_like :pass_through_content_type

    describe 'body' do
      it do
        expect(request.body).to eq JSON::JWT.new(body).to_s
      end
    end
  end

  context 'when Content-Type is application/jwt' do
    let(:content_type) { 'application/jwt' }

    context 'when body is nil' do
      let(:body) { nil }
      it_behaves_like :encode_body
    end

    context 'when body is empty' do
      let(:body) { '' }
      it_behaves_like :pass_through_request
    end

    context 'when body is a string' do
      let(:body) { 'eyJ...' }
      it_behaves_like :pass_through_request
    end

    context 'when body is an object' do
      let(:body) { {foo: :bar} }
      it_behaves_like :encode_body
    end
  end

  [nil, 'application/json'].each do |content_type|
    context "when Content-Type is #{content_type || 'nil'}" do
      let(:content_type) { content_type }

      context 'when body is nil' do
        let(:body) { nil }
        it_behaves_like :pass_through_request
      end

      context 'when body is empty' do
        let(:body) { '' }
        it_behaves_like :pass_through_request
      end

      context 'when body is a string' do
        let(:body) { 'eyJ...' }
        it_behaves_like :pass_through_request
      end

      context 'when body is an object' do
        let(:body) { {foo: :bar} }
        it_behaves_like :pass_through_request
      end
    end
  end
end