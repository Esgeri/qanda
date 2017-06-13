class DeleteColumnRatingFromAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_column :answers, :rating
  end
end
