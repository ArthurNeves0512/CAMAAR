# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      ## Campos personalizados
      t.string :matricula, null: false
      t.string :nome, null: false
      t.string :role, default: "" # Exemplo: 'admin', 'professor', 'aluno'

      ## Devise padrão
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Confirmação de conta (opcional)
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      ## Reset de senha
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Lembrar de mim
      t.datetime :remember_created_at

      ## Trackable (se necessário)
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Timestamps padrão
      t.timestamps null: false
    end

    # Adicionando índices únicos corretamente
    add_index :users, :email, unique: true
    add_index :users, :matricula, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
