class CreateSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :subjects do |t|
      t.string :name, limit: 45
      t.string :code, limit: 45
      t.references :department, null: false, foreign_key: true
      t.timestamps
    end
  end
end
