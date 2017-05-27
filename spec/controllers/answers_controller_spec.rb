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
          delete :destroy, params: { id: answer, question_id: question, format: :js }
        end.to change(Answer, :count).by(-1)
      end

      it 'render to template destroy on question show view' do
        delete :destroy, params: { id: answer, question_id: question, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'No author can not delete answer' do
      let!(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, user: another_user) }

      it 'can not delete' do
        expect do
          delete :destroy, params: { id: answer, question_id: question, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'render to template destroy on question show view' do
        delete :destroy, params: { id: answer, question_id: question, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #mark_best' do
    context 'Authenticated user' do
      sign_in_user

      let!(:answer) { create(:answer, question: question, user: @user) }
      let!(:another_user) { create(:user) }
      let!(:another_question) { create(:question, user: another_user) }
      let!(:another_answer) { create(:answer, question: another_question, user: another_user) }

      it 'mark best answer' do
        patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        answer.reload
        expect(answer.best).to eq true
      end

      it 'no author do not mark answer as best' do
        patch :mark_best, params: { id: another_answer, question_id: another_question, answer: attributes_for(:answer), format: :js }
        another_answer.reload
        expect(another_answer.best).to eq false
      end

      it 'should be only one best answer' do
        patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render best template' do
        patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :mark_best
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer, question: question) }
      it 'can not mark best answer' do
        patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end
end
