require 'rails_helper'

RSpec.describe class: 'Api::V1::AnswersController', type: :controller do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'

      it 'returns list of answers' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at best rating).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    let!(:comment) { create(:comment, commentable: answer, user: user) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'API Status 200'

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Attachable'
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { answer: answer, format: :json, access_token: access_token.token } }

      context 'with valid attributes' do
        let(:answer) { attributes_for(:answer, question: question, body: 'New_Body') }

        it 'creates and returns a new answer' do
          expect(response.status).to eq 201

          get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
          expect(response.body).to have_json_size(1)
          expect(response.body).to be_json_eql('New_Body'.to_json).at_path('0/body')
        end
      end

      context 'with invalid attributes' do
        let(:answer) { attributes_for(:answer, question: question, body: '') }

        it 'doesn\'t save an answer, renders errors' do
          expect(response.status).to eq 422
          expect(response.body).to have_json_path('errors')

          get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
          expect(response.body).to have_json_size(0)
        end
      end
    end
  end

  def do_request(options = {})
    post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
  end
end
