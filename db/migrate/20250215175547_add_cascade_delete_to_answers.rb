class AddCascadeDeleteToAnswers < ActiveRecord::Migration[8.0]
  def change
    # Remover a chave estrangeira existente entre answers e questionnaires
    remove_foreign_key :answers, :questionnaires

    # Adicionar a chave estrangeira com a opção on_delete: :cascade
    add_foreign_key :answers, :questionnaires, on_delete: :cascade
  end
end
