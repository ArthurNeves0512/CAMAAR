Feature: Edição e deleção de templates

  Eu como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Background:
    Given Que estou na pagina Editar Templates
    And Existe templates


  Scenario: Tentar editar template (Caminho Feliz)
    When Eu clico em "editar"
    Then Devo ver "Modal Edição Template"

    Given Que o usuário preenche os campos corretamente e submete o formulário
    Then O template deve ser atualizado


  Scenario: Tentar editar template (Caminho Triste)
    When Eu clico em "editar"
    Then Devo ver "Modal Edição Template"

    Given Que o usuário preenche os campos incorretamente e submete o formulário
    Then Devo ver "Dados invalidos, por favor preencha corretamente"


  Scenario: Tentar deletar template (Caminho Feliz)
    When Eu clico em "deletar"
    Then Devo ver "Removido com sucesso"
    And O template deve ser removido da lista


  Scenario: Tentar deletar template (Caminho Triste)
    When Eu clico em "deletar"
    Then Devo ver "Removido com sucesso"
    But O template não deve ser removido da lista

