Feature: Sistema de definição de senha

    Eu como Usuário,
    Quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro,
    A fim de acessar o sistema.

    Scenario: Definir senha com sucesso
        Given que eu recebi um e-mail do sistema com um link para definir minha senha,
        And o link no e-mail ainda está válido,
        When eu clico no link para definir minha senha,
        And eu preencho os campos "Nova Senha" e "Confirmar Senha" com valores iguais,
        And clico no botão "Salvar Senha",
        Then o sistema confirma que minha senha foi definida com sucesso,
        And eu posso acessar o sistema com meu usuário e senha recém-definidos.

    Scenario: Link expirado ou inválido (Cenário triste)
        Given que eu recebi um e-mail do sistema com um link para definir minha senha,
        And o link no e-mail está expirado ou inválido,
        When eu tento acessar o link,
        Then o sistema exibe uma mensagem informando que o link é inválido ou expirado,
        And me orienta a solicitar um novo link para definição de senha.
