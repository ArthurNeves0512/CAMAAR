Feature: Visualização de resultados dos formulários

    - Eu como Administrador
    - Quero visualizar os formulários criados
    - A fim de poder gerar um relatório a partir das respostas

    Scenario: Visualizar formularios presentes no banco de dados (happy path)
        Given que o Administrador está logado no sistema
        And o Administrador encontra-se na pagina de visualizar formularios
        When o Administrador deseja gerar um relatório a partir das respostas dos formularios
        And ele clica no botão "gerar relatorio"
        Then o sistema deve gerar um relatorio a partir das respostas dos formularios
        And exibir para o Administrador o relatorio gerado a partir das respostas dos formularios

    Scenario: Visualizar formularios presentes no banco de dados (sad path)
        Given que o Administrador está logado no sistema
        And o Administrador encontra-se na pagina de visualizar formularios
        When o Administrador deseja gerar um relatório a partir das respostas dos formularios
        And ele clica no botão "gerar relatorio"
        Then o sistema deve exibir a mensagem "Não há dados de respostas suficientes nos formularios para gerar um relatorio."
        And exibir novamente a pagina inicial de visualizar formularios