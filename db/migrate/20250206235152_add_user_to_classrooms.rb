class AddUserToClassrooms < ActiveRecord::Migration[8.0]
  def change
    add_reference :classrooms, :teacher, null: false, foreign_key: { to_table: :users }
  end
end
