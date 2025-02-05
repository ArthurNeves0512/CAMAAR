class CreateCoordinators < ActiveRecord::Migration[8.0]
  def change
    create_table :coordinators do |t|
      t.references :user, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.timestamps
    end
  end
end
