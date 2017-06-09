class AddColumnToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :votable_id, :integer
    add_column :votes, :votable_type, :string
    add_belongs_to :votes, :user
    add_index :votes, [:votable_id, :votable_type]
  end
end
