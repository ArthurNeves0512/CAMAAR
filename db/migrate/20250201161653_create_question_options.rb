class CreateQuestionOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :question_options do |t|
      t.string :name, limit: 45
      t.string :text, limit: 45
      t.references :question, null: false, foreign_key: true
      t.timestamps
    end
  end
end
