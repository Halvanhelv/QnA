# frozen_string_literal: true

shared_examples_for 'API Create resource' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass) { resource.to_s.downcase.to_sym }

  context 'with valid data' do
    it 'returns 200 status' do
      do_request(method, api_path, params: { klass => valid_attrs, access_token: access_token.token }, headers: headers)
      expect(response).to be_successful
    end

    it 'saves a new resource in the database' do
      expect do
        do_request(method, api_path, params: { access_token: access_token.token, klass => valid_attrs }, headers: headers)
      end.to change(resource, :count).by(1)
    end

    it 'saves with correct attributes' do
      do_request(method, api_path, params: { klass => valid_attrs, access_token: access_token.token }, headers: headers)
      expect(assigns(klass).body).to eq valid_attrs[:body]
    end
  end

  context 'with invalid data' do
    it 'does not save a new resource in the database' do
      expect do
        do_request(method, api_path, params: { access_token: access_token.token, klass => invalid_attrs }, headers: headers)
      end.to_not change(resource, :count)
    end

    it 'returns 422 status' do
      do_request(method, api_path, params: { klass => invalid_attrs, access_token: access_token.token }, headers: headers)
      expect(response).to have_http_status(422)
    end
  end
end
