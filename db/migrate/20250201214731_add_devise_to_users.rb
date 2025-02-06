class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      # Campos padrão
      t.string :matricula, null: false
      t.string :nome, null: false
      t.integer :role, default: 0, null: false # 0=dicente | 1=docente | 2=admin

      # Devise padrão
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      # Confirmação de conta (opcional)
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      # Reset de senha
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      # Data de criação
      t.datetime :remember_created_at

      # Timestamps padrão
      t.timestamps null: false

      # Informações da Universidade
      t.string :highest_degree
      t.string :active_degree

      # Docente
      t.references :department, null: true, foreign_key: true
    end

    # Adicionando índices únicos corretamente
    add_index :users, :email, unique: true
    add_index :users, :matricula, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
