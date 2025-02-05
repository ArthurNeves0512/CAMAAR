Feature: Atualizar base de dados com os dados do SIGAA

    Eu como Administrador. Quero atualizar a base de dados já existente com os dados atuais do SIGAA. A fim de corrigir a base de dados do sistema.

    Scenario: Alterar o valor de um dado no sistema (happy path)
        Given que o Administrador está logado no sistema
        And o Administrador encontra-se na página de modificar dados do sistema
        When o Administrador seleciona o dado nomeado de "rootPassword" com o valor "senhaAntiga"
        And ele insere que o novo valor para o dado selecionado será "senhaNova" e clica em "Salvar"
        Then o sistema deve alterar no banco de dados o dado selecionado com o novo valor inserido
        And deve-se então exibir ao Administrador que o dado selecionado "rootPassword" agora possui o valor "senhaNova"

    Scenario: Alterar o valor de um dado no sistema (sad path)
        Given que o Administrador está logado no sistema
        And o Administrador encontra-se na página de modificar dados do sistema
        When o Administrador seleciona o dado nomeado de "rootPassword" com o valor "senhaAntiga"
        And ele insere que o novo valor para o dado selecionado será "senhaNova" e clica em "Salvar"
        Then o sistema deve exibir a mensagem "Não foi possivel alterar o dado selecionado: erro no banco de dados."
        And o sistema exibe que o valor do dado permanece o mesmo