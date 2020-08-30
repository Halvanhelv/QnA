shared_examples_for 'API Update resource' do
  let(:klass) { resource.to_s.downcase.to_sym }

  context 'with valid data' do
    before { do_request(method, api_path, params: { klass => valid_attrs, access_token: access_token.token }, headers: headers) }
    it 'return 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'updated with correct body' do
      expect(assigns(klass).body).to eq valid_attrs[:body]
    end
  end

  context 'with invalid data' do
    before { do_request(method, api_path, params: { klass => invalid_attrs, access_token: access_token.token }, headers: headers) }

    it 'return 422 status' do
      expect(response).to have_http_status(422)
    end

    it 'does not update the question' do
      expect(assigns(klass).reload.body).to_not eq invalid_attrs[:body]
    end
  end
end
