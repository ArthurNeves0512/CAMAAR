Feature: Importar dados do SIGAA

    - Eu como Administrador
    - A fim de alimentar a base de dados do sistema atual
    - Quero importar os dados do SIGAA de turmas, materias e participantes caso não existam na base atual

    Background:
        Given Que estou na pagina Principal
        When Eu clico em "Gerenciamento"
        Then Devo estar na pagina Gerenciamento

    Scenario: Tentar importar os dados (Caminho Feliz)
        Given Não existe materias
        When Eu clico em "Importar Dados"
        Then Devo ver "Dados importados" na pagina Gerenciamento
        And Devo estar na pagina Principal
        And Devo ver materias

    Scenario: Tentar importar os dados (Caminho Triste)
        Given Existe materias
        When Eu clico em "Importar Dados"
        Then Devo ver "Os dados ja foram importados anteriormente" na pagina Gerenciamento
        And Devo estar na pagina Principal