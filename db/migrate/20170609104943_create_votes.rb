class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.boolean :is_liked

      t.timestamps null: false
    end
  end
end
