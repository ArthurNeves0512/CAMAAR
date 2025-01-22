Feature: Login no sistema
  Como um Usuário do sistema
  Eu quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

  Scenario: Login bem-sucedido com e-mail
    Given que o usuário está na página de login
    When ele insere um e-mail válido "usuario@example.com" no campo "E-mail ou Matrícula"
    And ele insere a senha válida "senha123" no campo "Senha"
    And ele clica no botão "Entrar"
    Then ele deve ser redirecionado para a página inicial do sistema
    And deve ver a mensagem "Bem-vindo ao sistema!"

  Scenario: Login bem-sucedido com matrícula
    Given que o usuário está na página de login
    When ele insere uma matrícula válida "123456" no campo "E-mail ou Matrícula"
    And ele insere a senha válida "senha123" no campo "Senha"
    And ele clica no botão "Entrar"
    Then ele deve ser redirecionado para a página inicial do sistema
    And deve ver a mensagem "Bem-vindo ao sistema!"

  Scenario: Usuário professor e admin acessa o sistema
    Given que o usuário é um professor com o atributo "administrador" como verdadeiro e está logado
    When ele acessa a página inicial do sistema
    Then ele deve ver a opção "Gerenciamento" no menu lateral

  Scenario: Usuário professor não admin acessa o sistema
    Given que o usuário é um professor com o atributo "administrador" como falso e está logado
    When ele acessa a página inicial do sistema
    Then ele não deve ver a opção "Gerenciamento" no menu lateral

  Scenario: Login com credenciais inválidas
    Given que o usuário está na página de login
    When ele insere "invalido@example.com" no campo "E-mail ou Matrícula"
    And ele insere "senhaincorreta" no campo "Senha"
    And ele clica no botão "Entrar"
    Then ele deve permanecer na página de login
    And deve ver a mensagem "Email ou senha inválidos"
