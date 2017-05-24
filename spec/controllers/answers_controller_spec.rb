require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'saves the answer with current user' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :errors
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:answer) { create(:answer, question: question, user: @user) }

    context 'as an author edit the answer' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns to question' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' } , format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'when not the author' do
      sign_in_user

      let!(:answer) { create(:answer, question: question) }

      it 'no edit answer' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
        answer.reload
        expect(answer.body).to eq answer.body
      end
    end

    context 'with invalid attributes' do
      it 'answer attribute not be nil' do
        patch :update, params: { id: answer, question_id: question, answer: { body: nil }, format: :js }
        answer.reload
        expect(answer.body).to_not be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'Author can delete his own answer' do
      let!(:answer) { create(:answer, user: @user, question: question) }

      it 'delete answer' do
        expect do
          delete :destroy, params: { id: answer, question_id: question }
        end.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'No author can not delete answer' do
      let!(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, user: another_user) }

      it 'can not delete' do
        expect do
          delete :destroy, params: { id: answer, question_id: question }
        end.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
