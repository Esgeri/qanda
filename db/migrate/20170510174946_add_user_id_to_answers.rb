class AddUserIdToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :user, index: true, foreign_key: true
  end
end
