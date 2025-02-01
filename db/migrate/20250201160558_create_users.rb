class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :registration_number, limit: 45
      t.string :email, limit: 100, null: false
      t.string :name, limit: 100
      t.string :role, limit: 45
      t.string :password_digest
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end

