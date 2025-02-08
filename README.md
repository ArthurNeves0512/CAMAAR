# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

## 🚀 Como Rodar a Aplicação  

```sh
# 1️⃣ Instalar as dependências
bundle install

# 2️⃣ Configurar o banco de dados de desenvolvedor
rails db:reset  # Apaga, recria e carrega o schema e seeds

#  Rodar os seeds separadamente
rails db:seed

# 3️⃣ Resetar o banco de testes
rails db:test:prepare  # Prepara o banco de testes

# (Alternativa) Recriar completamente o banco de testes
rails db:reset RAILS_ENV=test

# 4️⃣ Rodar a aplicação
rails server  # Inicia o servidor em http://localhost:3000

# 5️⃣ Rodar os testes de feature
rspec spec/features  # Roda todos os testes de feature

# (Opcional) Rodar um teste específico
rspec spec/features/nome_do_teste_spec.rb
