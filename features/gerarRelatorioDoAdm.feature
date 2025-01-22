Feature: Gerar Relatorio do administrador

    - Como Administrador
    - Eu quero baixar um arquivo CSV contendo os resultados de um formulário
    - A fim de avaliar o desempenho das turmas

    Scenario: Download de resultados com sucesso
        Given que o administrador está logado no sistema
        And o administrador está na página de resultados de formulário
        When ele seleciona um formulário de Avaliação da turma "Turma A"
        And ele clica no botão "Exportar para CSV"
        Then o sistema deve gerar um arquivo CSV contendo os resultados associaos ao formulário
        And o arquivo deve ser baixado automaticamente com o nome "relatorio_formulario_Turma_A.csv"

    Scenario: Download de resultados vazios do formulário
        Given que o administrador está logado no sistema
        And o administrador está na página de resultados do formulário
        When ele seleciona um formulário vazio da turma "Turma B"
        And ele clica no botão "Exportar para CSV"
        Then o sistema deve exibir a mensagem "Este formulário não possui resultados para exportar."
        And nenhum arquivo CSV deve ser baixado