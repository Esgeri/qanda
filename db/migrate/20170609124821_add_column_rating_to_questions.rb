class AddColumnRatingToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :rating, :integer, default: 0
    add_index :questions, :rating
  end
end
