Feature: Criação de formulario

    - Eu como Administrador
    - A fim de avaliar o desempenho de uma materia
    - Quero escolher criar um formulário para os docentes ou os dicentes de uma turma

    Background:
        Given Que estou na pagina Principal
        And Eu cliquei em "Criar Formulario"

    Scenario: Tentar criar formulario (Caminho Feliz)
        Given Existe materias
        And Existe template
        Then Devo estar na pagina Criar-Formulario
        Given que existe campos criados
        When Eu clico em "Criar"
        Then Devo ver o formulario na pagina Principal

    Scenario: Tentar criar formulário (Caminho Triste ausência de materias)
        Given Não existe materias
        Then Devo ver "Não é possível criar formulário devido ausência de materias" na pagina Principal