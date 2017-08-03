require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do

    context 'Authenticated user can delete question files' do
      context 'Author of question' do
        sign_in_user
        let(:question) { create(:question, user: @user) }
        let!(:question_attachment) { create(:attachment, attachable: question) }

        it 'delete question file' do
          question_attachment
          expect { delete :destroy, params: { id: question_attachment }, format: :js }.to change(question.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: { id: question_attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'No author' do
        sign_in_user
        let(:question) { create(:question) }
        let!(:question_attachment) { create(:attachment, attachable: question) }

        it 'delete question file' do
          question_attachment
          expect { delete :destroy, params: { id: question_attachment }, format: :js }.to_not change(question.attachments, :count)
        end

        it 'sends 403 status' do
          delete :destroy, params: { id: question_attachment }, format: :js
          expect(response).to have_http_status(403)
        end
      end

      context 'Unauthenticated user try delete question' do
        let(:question) { create(:question) }
        let!(:question_attachment) { create(:attachment, attachable: question) }

        it 'delete question file' do
          question_attachment
          expect { delete :destroy, params: { id: question_attachment }, format: :js }.to_not change(question.attachments, :count)
        end
      end
    end

    context 'Authenticated user can delete answer files' do
      context 'Author of answer' do
        sign_in_user
        let(:question){ create(:question, user: @user)}
        let(:answer){ create(:answer, user: @user, question: question)}
        let(:answer_attachment){ create(:attachment, attachable: answer)}

        it 'delete question file' do
          answer_attachment
          expect { delete :destroy, params: { id: answer_attachment }, format: :js }.to change(answer.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: { id: answer_attachment }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'No author of answer' do
        sign_in_user
        let(:question){ create(:question)}
        let(:answer){ create(:answer, question: question)}
        let(:answer_attachment){ create(:attachment, attachable: answer)}

        it 'delete question file' do
          answer_attachment
          expect { delete :destroy, params: { id: answer_attachment }, format: :js }.to_not change(answer.attachments, :count)
        end

        it 'sends 403 status' do
          delete :destroy, params: { id: answer_attachment }, format: :js
          expect(response).to have_http_status(403)
        end
      end

      context 'Unauthenticated user try delete question' do
        let(:question) { create(:question) }
        let(:answer){ create(:answer, question: question)}
        let(:answer_attachment){ create(:attachment, attachable: answer)}

        it 'delete question file' do
          answer_attachment
          expect { delete :destroy, params: { id: answer_attachment }, format: :js }.to_not change(answer.attachments, :count)
        end
      end
    end
  end
end
