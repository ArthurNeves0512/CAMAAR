class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :name, limit: 45
      t.string :text, limit: 255
      t.string :question_type, limit: 45
      t.references :template, null: false, foreign_key: true
      t.timestamps
    end
  end
end
