Feature: Visualizar resultados das avaliações
  Como Administrador
  Quero acessar e visualizar os resultados das avaliações
  Para analisar dados por departamento, semestre e ano

  Background:
    Given que estou autenticado como administrador no sistema para visualizar resultados 

  Scenario: Navegar até a página de enviar formulários
    Given que estou na página inicial do sistema
    When eu clico no ícone de menu
    And eu clico no botão "Gerenciamento"
    And eu clico no botão "Enviar formulários"
    Then devo ser redirecionado para a página de enviar formulários
    And devo ver os filtros "Código" e "Semestre"

  Scenario: Filtrar resultados por código e semestre
    Given que estou na página de enviar formulários
    When eu seleciono "CIC1024" no filtro "Código"
    And eu seleciono "2024.1" no filtro "Semestre"
    And eu clico no botão "Aplicar Filtros"
    Then devo ver os resultados de "Ciências da Computação" semestre "2024.1"

  Scenario: Falha ao navegar para a página de enviar formulários
    Given que estou na página inicial do sistema
    When eu clico no ícone de menu
    And eu clico no botão "Gerenciamento"
    And eu clico no botão "Enviar formulários"
    Then devo ver uma mensagem de erro "Página não encontrada"
    And devo ser redirecionado de volta à página inicial

  Scenario: Falha ao aplicar filtros para visualizar resultados
    Given que estou na página de enviar formulários
    When eu seleciono "CIC1024" no filtro "Código"
    And eu seleciono "2024.1" no filtro "Semestre"
    And eu clico no botão "Aplicar Filtros"
    Then devo ver uma mensagem de erro "Nenhum dado encontrado para os filtros aplicados"
    And a tabela de resultados deve estar vazia