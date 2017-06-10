class ChangeColumnIsLikedToValueInVotes < ActiveRecord::Migration[5.1]
  def change
    remove_column :votes, :is_liked
    add_column :votes, :value, :integer
  end
end
