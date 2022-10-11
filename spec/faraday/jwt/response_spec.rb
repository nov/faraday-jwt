# frozen_string_literal: true

RSpec.describe Faraday::JWT::Response do
  let(:faraday) do
    Faraday.new do |conn|
      conn.response :jwt, **options
      conn.adapter :test do |stub|
        stub.post('/') do |env|
          [200, { 'Content-Type' => env[:request_headers]['Content-Type'] }, env[:body]]
        end
      end
    end
  end
  let(:options) { {} }
  let(:response) { faraday.post('/', body, 'Content-Type': content_type) }

  shared_examples :pass_through_content_type do
    describe 'Content-Type' do
      it do
        expect(response.headers['Content-Type']).to eq content_type
      end
    end
  end

  shared_examples :pass_through_response do
    it_behaves_like :pass_through_content_type

    describe 'body' do
      it do
        expect(response.body).to eq body || ''
      end
    end
  end

  shared_examples :decode_body do
    it_behaves_like :pass_through_content_type

    describe 'body' do
      it do
        expect(response.body).to eq JSON::JWT.decode(body)
      end
    end
  end

  context 'when Content-Type is application/jwt' do
    let(:content_type) { 'application/jwt' }

    context 'when body is nil' do
      let(:body) { nil }
      it_behaves_like :pass_through_response
    end

    context 'when body is empty' do
      let(:body) { '' }
      it_behaves_like :pass_through_response
    end

    context 'when body is a string' do
      let(:body) { 'eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJmb28iOiJiYXIifQ.' }
      it_behaves_like :decode_body
    end

    context 'when body is an object' do
      let(:body) { {foo: :bar} }
      it_behaves_like :pass_through_response
    end
  end

  [nil, 'application/json'].each do |content_type|
    context "when Content-Type is #{content_type || 'nil'}" do
      let(:content_type) { content_type }

      context 'when body is nil' do
        let(:body) { nil }
        it_behaves_like :pass_through_response
      end

      context 'when body is empty' do
        let(:body) { '' }
        it_behaves_like :pass_through_response
      end

      context 'when body is a string' do
        let(:body) { 'eyJ...' }
        it_behaves_like :pass_through_response
      end

      context 'when body is an object' do
        let(:body) { {foo: :bar} }
        it_behaves_like :pass_through_response
      end
    end
  end
end
