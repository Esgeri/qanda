class AddUserIdToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :user, index: true, foreign_key: true
  end
end
