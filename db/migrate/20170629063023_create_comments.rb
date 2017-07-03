class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :commentable_id
      t.string :commentable_type
      t.index [:commentable_id, :commentable_type]
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
