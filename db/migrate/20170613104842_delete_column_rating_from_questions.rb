class DeleteColumnRatingFromQuestions < ActiveRecord::Migration[5.1]
  def change
    remove_column :questions, :rating
  end
end
