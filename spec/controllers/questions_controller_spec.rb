require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'save the question with current user' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'sends 403 status' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        expect(response).to have_http_status(403)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil }, format: :js } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'sends 403 status' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when not the author' do
      sign_in_user

      it 'no edit question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    before { question }

    context 'Author can delete his own question' do
      let(:question) { create(:question, user: @user) }

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'No author can not delete question' do
      let!(:another_user) { create(:user) }
      let!(:question) { create(:question, user: another_user) }

      it 'can not delete' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to root path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #vote' do
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:another_user) { create(:user) }

    context 'author of question can not vote' do
      before { sign_in(author) }

      it 'should not vote like' do
        patch :set_like, params: { id: question.id }, format: :json
        expect { patch :set_like, params: { id: question.id }, format: :json }.to_not change(question.votes, :count)
      end

      it 'should not vote dislike' do
        patch :set_dislike, params: { id: question.id }, format: :json
        expect { patch :set_dislike, params: { id: question.id }, format: :json }.to_not change(question.votes, :count)
      end
    end

    context 'no author can vote' do
      before { sign_in(another_user) }

      it 'should vote like' do
        expect { patch :set_like, params: { id: question.id }, format: :json }.to change(question.votes, :count).by(1)
      end

      it 'should vote dislike' do
        expect { patch :set_dislike, params: { id: question.id }, format: :json }.to change(question.votes, :count).by(1)
      end

      it 'should vote like one time' do
        patch :set_like, params: { id: question.id }, format: :json
        expect { patch :set_like, params: { id: question.id }, format: :json }.to_not change(question.votes, :count)
      end

      it 'should vote dislike one time' do
        patch :set_dislike, params: { id: question.id }, format: :json
        expect { patch :set_dislike, params: { id: question.id }, format: :json }.to_not change(question.votes, :count)
      end
    end

    context 'only no author can unvote' do
      before { sign_in(another_user) }

      it 'should unvote' do
        patch :set_like, params: { id: question.id }, format: :json
        expect { delete :cancel_vote, params: { id: question.id }, format: :json }.to change(question.votes, :count).by(-1)
      end
    end
  end
end
