# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC

## 🚀 Como Rodar a Aplicação  

### 1️⃣ Criar o arquivo de configuração do banco de dados
Antes de mais nada, é necessário criar um arquivo `config/database.yml` com as credenciais do seu banco de dados PostgreSQL. Aqui está um exemplo básico de configuração:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: <seu_usuario_postgresql>
  password: <sua_senha_postgresql>
  host: localhost

development:
  <<: *default
  database: nome_do_banco_de_dados_development

test:
  <<: *default
  database: nome_do_banco_de_dados_test

production:
  <<: *default
  database: nome_do_banco_de_dados_production
  username: <seu_usuario_postgresql>
  password: <sua_senha_postgresql>
```

2️⃣ Instalar as dependências
```
bundle install
```
3️⃣ Configurar o banco de dados de desenvolvedor
```
    rails db:reset  # Apaga, recria o bando de dados e carrega o schema e seeds povoando as tabelas do banco de dados
   
    rails db:seed  #Rodar os seeds separadamente:
```
4️⃣ Resetar o banco de testes (para testes de features)
```
rails db:reset RAILS_ENV=test #recria o banco e executa as seeds no banco de teste
```
5️⃣ Rodar a aplicação
```
rails server  # Inicia o servidor em http://localhost:3000
```
6️⃣ Rodar os testes de feature
```
rspec spec/features  # Roda todos os testes de feature

rspec spec/features/nome_do_teste_spec.rb #(Opcional) Rodar um teste específico:
```

