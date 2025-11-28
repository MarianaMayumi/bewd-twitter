class CreateSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :sessions do |t|
      t.string :token, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :sessions, :token, unique: true
    add_index :sessions, :user_id
  end
end
