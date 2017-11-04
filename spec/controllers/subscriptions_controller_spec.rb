require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question_author_user) { create(:user) }
  let(:question) { create(:question) }
  let!(:subscription) { create(:subscription, user_id: question_author_user.id, question_id: question.id) }
  let(:no_author_user) { create(:user) }

  describe 'POST #create' do
    context 'Authorized user' do
      before { sign_in(no_author_user) }

      it 'saves the new subscription for question into the database' do
        expect { post :create, params: { question_id: question.id, format: :js } }.to change(Subscription, :count).by(1)
      end

      it 'subscription belongs to user' do
        post :create, params: { question_id: question.id, format: :js }
        expect(Subscription.last.user).to eq(no_author_user)
      end

      it 'render create template' do
        post :create, params: { question_id: question.id, format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'Unauthorized user' do
      it 'tries to subscribe' do
        expect { post :create, params: { question_id: question.id, user: nil } }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authorized user' do
      context "question's author subscription" do
        before { sign_in(question_author_user) }

        it 'destroy subscription' do
          expect { delete :destroy, params: { id: subscription.id, format: :js } }.to change(Subscription, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: { id: subscription.id, format: :js }
          expect(response).to redirect_to question
        end
      end

      context 'not question author subscription' do
        let(:no_author_subscription) { create(:subscription, user_id: no_author_user.id, question_id: question.id) }

        before { sign_in(no_author_user) }

        it 'delete subscription' do
          expect { delete :destroy, params: { id: no_author_subscription.id, format: :js } }.to_not change(Subscription, :count)
        end

        it 'render template' do
          delete :destroy, params: { id: no_author_subscription.id, format: :js }
          expect(response).to redirect_to question
        end
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete ' do
        expect { delete :destroy, params: { id: subscription.id, format: :js } }.to_not change(Subscription, :count)
      end
    end
  end
end
