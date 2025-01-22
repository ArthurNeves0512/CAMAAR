Feature: Cadastrar usuários do sistema

    - Eu como Administrador
    - Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos para o sistema
    - A fim de que eles acessem o sistema CAMAAR

    Scenario: Importação de dados e envio de solicitação de definição de senha
        Given que eu sou um administrador autenticado no sistema
        And eu tenho um arquivo válido contendo os dados de novos participantes exportados do SIGAA
        When eu acesso a funcionalidade de "Importar Participantes"
        And faço o upload do arquivo com os dados
        Then o sistema processa os dados
        And envia um e-mail para cada participante com um link para definir sua senha
        And os participantes aparecem na lista de usuários pendentes até que definam suas senhas

    Scenario: Importação com arquivo inválido
        Given que eu sou um administrador autenticado no sistema
        And eu tenho um arquivo inválido (exemplo: formato errado ou dados incompletos)
        When eu acesso a funcionalidade de "Importar Participantes"
        And faço o upload do arquivo inválido
        Then o sistema exibe uma mensagem de erro informando o motivo da falha
        And nenhum participante é cadastrado no sistema

    Scenario: Participante define sua senha e conclui o cadastro
        Given que o sistema enviou um e-mail para o participante com o link de definição de senha
        And o participante acessa o link de definição de senha
        And define sua senha corretamente
        When o sistema confirma a criação da senha
        Then o cadastro do participante é efetivado
        And ele aparece como um usuário ativo no sistema

    Scenario: Erro ao processar o arquivo de importação
        Given que eu sou um administrador autenticado no sistema
        And eu tenho um arquivo válido contendo os dados de novos participantes exportados do SIGAA
        When eu acesso a funcionalidade de "Importar Participantes"
        And faço o upload do arquivo com os dados
        Then ocorre um erro no processamento dos dados devido a problemas internos no sistema
        And o sistema exibe uma mensagem de erro informando que a importação falhou
        And nenhum participante é cadastrado no sistema