require 'rails_helper'

RSpec.describe class: 'Api::V1::ProfilesController', type: :controller do
  describe 'GET /profiles/me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /profiles/index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users[2].id) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'

      %w(id email created_at updated_at admin).each do |attr|
        it "contains other users data - #{attr}" do
          expect(response.body).to be_json_eql(users[0].send(attr.to_sym).to_json).at_path("0/#{attr}")
          expect(response.body).to be_json_eql(users[1].send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain other users data - #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
          expect(response.body).to_not have_json_path("1/#{attr}")
        end
      end

      it "does not contain current user data" do
        expect(response.body).to_not have_json_path("2")
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end
