class CreateQuestionnaires < ActiveRecord::Migration[8.0]
  def change
    create_table :questionnaires do |t|
      t.string :name, limit: 45
      t.string :classroom_info, limit: 100
      t.references :template, null: false, foreign_key: true
      t.timestamps
    end
  end
end
