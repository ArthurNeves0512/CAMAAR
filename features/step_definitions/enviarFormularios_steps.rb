Given("que estou autenticado como administrador no sistema para envio de formulários") do
  pending "Implementar autenticação como administrador"
end

Given("que estou na página inicial do sistema") do
  pending "Implementar navegação para a página inicial"
end

When("eu clico no ícone de menu") do
  pending "Implementar clique no ícone de menu"
end

When("eu clico no botão {string}") do |botao|
  pending "Implementar clique no botão '#{botao}'"
end

Then("devo ser redirecionado para a página de envio de formulários") do
  pending "Implementar verificação do redirecionamento para a página de envio de formulários"
end

Then("devo ver uma lista de templates disponíveis") do
  pending "Implementar verificação da lista de templates disponíveis"
end

Then("devo ver filtros de {string} e {string}") do |filtro1, filtro2|
  pending "Implementar verificação dos filtros '#{filtro1}' e '#{filtro2}'"
end

Given("que estou na página de envio de formulários") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("há um template chamado {string} disponível") do |template|
  pending "Implementar a verificação de que o template '#{template}' está disponível"
end

When("eu seleciono o template {string}") do |template|
  pending "Implementar a seleção do template '#{template}'"
end

When("eu seleciono {string} no filtro {string}") do |valor, filtro|
  pending "Implementar a seleção de '#{valor}' no filtro '#{filtro}'"
end

When("eu clico no botão {string}") do |botao|
  pending "Implementar clique no botão '#{botao}'"
end

Then("devo ver uma mensagem de sucesso {string}") do |mensagem|
  pending "Implementar verificação da mensagem de sucesso '#{mensagem}'"
end

Then("devo ver uma mensagem de erro {string}") do |mensagem|
  pending "Implementar verificação da mensagem de erro '#{mensagem}'"
end

Then("devo ser redirecionado de volta à página inicial") do
  pending "Implementar verificação do redirecionamento de volta à página inicial"
end

When("eu tento selecionar o template {string}") do |template|
  pending "Implementar tentativa de seleção do template '#{template}'"
end

Then("o botão {string} deve estar desabilitado") do |botao|
  pending "Implementar verificação de que o botão '#{botao}' está desabilitado"
end

Then("o formulário não deve ser enviado para a turma") do
  pending "Implementar verificação de que o formulário não foi enviado"
end
