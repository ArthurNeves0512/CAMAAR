Feature: Gerenciar templates criados
  Como Administrador
  Quero visualizar os templates criados
  A fim de editar e/ou deletar um template existente no sistema

  Background:
    Given que estou autenticado como administrador

  Scenario: Visualizar a lista de templates
    Given que estou na página inicial do sistema
    When eu clico no ícone de menu
    And eu clico no botão "Gerenciamento"
    And eu clico no botão "Editar Templates"
    Then devo ver uma lista de templates criados
    And cada template deve ter ícones de "Editar" e "Excluir"

  Scenario: Editar um template
    Given que estou na página de templates criados
    When eu clico no ícone "Editar" de um template chamado "Avaliação 1"
    Then devo ser redirecionado para a página de edição do template
    And devo ver o título "Edição do Template: Avaliação 1"

  Scenario: Excluir um template
    Given que estou na página de templates criados
    When eu clico no ícone "Excluir" de um template chamado "Avaliação 1"
    Then devo ver uma mensagem "Template 'Avaliação 1' excluído com sucesso"
    And o template "Avaliação 1" não deve estar na lista
  
  Scenario: Falha ao carregar a lista de templates
    Given que estou na página inicial do sistema
    When eu clico no ícone de menu
    And eu clico no botão "Gerenciamento"
    And eu clico no botão "Editar Templates"
    Then devo ver uma mensagem de erro "Não foi possível carregar os templates no momento. Tente novamente mais tarde."
    And a lista de templates deve estar vazia

  Scenario: Erro ao tentar editar um template
    Given que estou na página de templates criados
    When eu clico no ícone "Editar" de um template chamado "Avaliação 1"
    Then devo ver uma mensagem de erro "Falha ao carregar o editor. Tente novamente mais tarde."
    And devo permanecer na página de templates criados

  Scenario: Falha ao excluir um template
    Given que estou na página de templates criados
    When eu clico no ícone "Excluir" de um template chamado "Avaliação 1"
    Then devo ver uma mensagem de erro "Erro ao excluir o template. Por favor, tente novamente."
    And o template "Avaliação 1" ainda deve estar na lista
