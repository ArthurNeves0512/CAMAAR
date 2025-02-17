# app/models/application_record.rb
# Modelo base para todos os outros modelos do Rails.
# Este é um modelo abstrato e não é instanciado diretamente.
# Ele fornece a base para todas as classes de modelos da aplicação,
# permitindo que os modelos herdem comportamentos e funcionalidades comuns.

class ApplicationRecord < ActiveRecord::Base
  # Definido como uma classe abstrata para que não seja instanciada diretamente
  # A definição de "primary_abstract_class" permite que a ApplicationRecord seja a classe base para todos os outros modelos.
  # Com isso, qualquer modelo que herde de ApplicationRecord poderá acessar métodos e comportamentos comuns a todos os modelos da aplicação.
  
  primary_abstract_class
end
