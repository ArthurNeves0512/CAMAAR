Feature: Enviar formulários para turmas específicas
  Como Administrador
  Quero selecionar templates e turmas para enviar formulários
  A fim de avaliar as atividades acadêmicas de forma eficiente

  Background:
    Given que estou autenticado como administrador no sistema para envio de formulários

  Scenario: Navegar para a página de envio de formulários
    Given que estou na página inicial do sistema
    When eu clico no ícone de menu
    And eu clico no botão "Gerenciamento"
    And eu clico no botão "Enviar Formulários"
    Then devo ser redirecionado para a página de envio de formulários
    And devo ver uma lista de templates disponíveis
    And devo ver filtros de "Código" e "Semestre"

  Scenario: Selecionar templates e enviar para turmas específicas
    Given que estou na página de envio de formulários
    And há um template chamado "Template A" disponível
    When eu seleciono o template "Template A"
    And eu seleciono "CIC1024" no filtro "Código"
    And eu seleciono "2024.1" no filtro "Semestre"
    And eu clico no botão "Enviar Formulário"
    Then devo ver uma mensagem de sucesso "Formulário enviado com sucesso!"
  
  Scenario: Falha ao carregar a página de envio de formulários
    Given que estou na página inicial do sistema
    When eu clico no ícone de menu
    And eu clico no botão "Gerenciamento"
    And eu clico no botão "Enviar Formulários"
    Then devo ver uma mensagem de erro "Erro ao carregar a página de envio de formulários. Tente novamente mais tarde."
    And devo ser redirecionado de volta à página inicial

  Scenario: Template não disponível para seleção
    Given que estou na página de envio de formulários
    And há um template chamado "Template A" disponível
    When eu tento selecionar o template "Template B"
    Then devo ver uma mensagem de erro "O template selecionado não está disponível no momento."
    And o botão "Enviar Formulário" deve estar desabilitado

  Scenario: Falha ao enviar formulário devido a erro no sistema
    Given que estou na página de envio de formulários
    And há um template chamado "Template A" disponível
    When eu seleciono o template "Template A"
    And eu seleciono "CIC1024" no filtro "Código"
    And eu seleciono "2024.1" no filtro "Semestre"
    And eu clico no botão "Enviar Formulário"
    Then devo ver uma mensagem de erro "Falha ao enviar o formulário. Por favor, tente novamente mais tarde."
    And o formulário não deve ser enviado para a turma