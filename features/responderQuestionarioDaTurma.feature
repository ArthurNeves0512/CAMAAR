Feature: Responder questionário sobre a turma
  Como Participante de uma turma
  Eu quero responder o questionário da turma em que estou matriculado
  A fim de submeter minha avaliação 

  Scenario: Participante acessa o questionário da turma
    Given que o participante está logado no sistema
    And está na página inicial
    When ele clica no link correspondente a o questionario da "Turma A" em que esta matriculado
    Then ele deve ser redirecionado para a página de preenchimento do questionário

  Scenario: Participante preenche e envia o questionário com sucesso
    Given que o participante está na página do questionário da sua turma 
    When ele preenche todas as perguntas obrigatórias
    And clica no botão "Enviar Resposta"
    Then ele deve ver a mensagem "Questionário enviado com sucesso!"
    And suas respostas devem ser registradas no sistema

  Scenario: Participante tenta enviar o questionário sem preencher todas as perguntas obrigatórias
    Given que o participante está na página do questionário da sua turma 
    When ele deixa algumas perguntas obrigatórias em branco
    And clica no botão "Enviar Resposta"
    Then ele deve ver a mensagem de erro "Por favor, preencha todas as perguntas obrigatórias antes de enviar."
    And o questionário não deve ser enviado
