Feature: criarTemplateDeFormulario

    Eu como Administrador. Quero criar um template de formulário contendo as questões do formulário. A fim de gerar formulários de avaliações para avaliar o desempenho das turmas.

    Scenario: Criar um novo template de formulario com questões (happy path)
        Given que o Administrador está logado no sistema
        And o Administrador encontra-se na pagina de criação de templates de formulario
        When o Administrador deseja criar um novo template
        And ele fornece as questões do formulario e clica no botão "criar template"
        Then o sistema deve criar um novo template a partir dos dados fornecidos
        And exibir para o Administrador o formulario criado a partir das questões forneceidas

    Scenario: Criar um novo template de formulario com questões (sad path)
        Given que o Administrador está logado no sistema
        And o Administrador encontra-se na pagina de criação de templates de formulario
        When o Administrador deseja criar um novo template
        And ele fornece as questões do formulario e clica no botão "criar template"
        Then o sistema deve exibir a mensagem "não foi possivel criar o template pois não há questões o suficiente!"
        And exibir para o Administrador o template para que ele possa adicionar os dados que estão faltando