class CreateDepartments < ActiveRecord::Migration[8.0]
  def change
    create_table :departments do |t|
      t.string :name, limit: 45, null: false
      t.timestamps
    end
  end
end
