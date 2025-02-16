class CreateClassrooms < ActiveRecord::Migration[8.0]
  def change
    create_table :classrooms do |t|
      t.string :code, limit: 45, null: false
      t.string :semester, limit: 45, null: false
      t.references :subject, null: false, foreign_key: true
      t.timestamps
      t.string :time, limit: 10, null: false
    end
    add_index :classrooms, [:code, :subject_id], unique: true
  end
end
