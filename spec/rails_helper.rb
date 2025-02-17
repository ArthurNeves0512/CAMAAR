# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
require "simplecov"
require "selenium-webdriver"
# Inicia o SimpleCov para rastrear a cobertura de testes
SimpleCov.start "rails" do
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/spec/"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

# Impede a execução dos testes se estiver no ambiente de produção
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "devise"
Capybara.javascript_driver = :selenium_chrome
# Configuração do RSpec
RSpec.configure do |config|
  # Configura helpers do Devise para diferentes tipos de testes
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Carrega automaticamente arquivos do diretório `spec/support/`
  Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

  # Verifica e aplica migrações pendentes antes de rodar os testes
  begin
    ActiveRecord::Migration.maintain_test_schema!
  rescue ActiveRecord::PendingMigrationError => e
    abort e.to_s.strip
  end

  # Define o diretório para fixtures do ActiveRecord
  config.fixture_paths = [Rails.root.join("spec/fixtures")]

  # Usa transações para limpar o banco de dados entre os testes
  config.use_transactional_fixtures = true

  # Filtra linhas do Rails nos backtraces para tornar os erros mais legíveis
  config.filter_rails_from_backtrace!
  # Filtrar gems arbitrárias, se necessário
  # config.filter_gems_from_backtrace("gem name")
end
