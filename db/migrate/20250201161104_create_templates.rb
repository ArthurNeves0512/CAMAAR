class CreateTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.string :name, limit: 45
      t.string :target_audience, limit: 45  
      t.string :semester, limit: 45
      t.timestamps
    end
  end
end
