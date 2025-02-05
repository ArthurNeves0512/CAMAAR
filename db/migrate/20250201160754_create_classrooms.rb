class CreateClassrooms < ActiveRecord::Migration[8.0]
  def change
    create_table :classrooms do |t|
      t.string :code, limit: 45
      t.string :semester, limit: 45
      t.references :subject, null: false, foreign_key: true
      t.timestamps
    end
  end
end
