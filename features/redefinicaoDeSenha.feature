Feature: Redefinição de senha

    - Como um usuário válido do sistema
    - Eu quero redefinir minha senha
    - Para recuperar o acesso ao sistema

    Scenario: Usuário solicita redefinição de senha e redefine com sucesso
        Given que o usuário está na página de redefinição de senha
        When ele insere um email válido "usuario@example.com" no campo de email
        And ele clica no botão "Enviar"
        Then ele deve ser redirecionado para a página de troca de senha de usuário

        Given que o usuário está na página de troca de senha
        When ele insere sua nova senha "novasenha123" no campo "Nova Senha"
        And ele clica no botão "Redefinir"
        Then ele deve ver a mensagem "Senha alterada com sucesso!"
        And sua senha deve ser atualizada no sistema

    Scenario: Usuário solicita redefinição de senha e insere um email inválido
        Given que o usuário está na página de redefinição de senha
        When ele insere um email inválido "emailinvalido@example.com" no campo de email
        And ele clica no botão "Enviar"
        Then ele deve ver uma mensagem de erro "Este email não está presente em nosso banco de dados"