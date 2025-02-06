# Arquivo: atualizarBaseDeDadosComOsDadosDoSIGAA_steps.rb

Given("que o Administrador está logado no sistema") do
  pending "Implementar lógica para autenticação do administrador"
end

Given("que o Administrador encontra-se na página de modificar dados do sistema") do
  pending "Implementar lógica para navegar até a página de modificar dados"
end

When("o Administrador seleciona o dado nomeado de {string} com o valor {string}") do |dado, valor|
  pending "Implementar lógica para selecionar o dado #{dado} com o valor #{valor}"
end

When("ele insere que o novo valor para o dado selecionado será {string} e clica em {string}") do |novo_valor, botao|
  pending "Implementar lógica para inserir o novo valor #{novo_valor} e clicar no botão #{botao}"
end

Then("o sistema deve alterar no banco de dados o dado selecionado com o novo valor inserido") do
  pending "Implementar lógica para verificar se o valor no banco de dados foi atualizado"
end

Then("deve-se então exibir ao Administrador que o dado selecionado {string} agora possui o valor {string}") do |dado, valor|
  pending "Implementar lógica para verificar a exibição de confirmação que o dado #{dado} agora possui o valor #{valor}"
end

Then("o sistema deve exibir a mensagem {string}") do |mensagem|
  pending "Implementar lógica para verificar a exibição da mensagem: #{mensagem}"
end

Then("o sistema exibe que o valor do dado permanece o mesmo") do
  pending "Implementar lógica para verificar que o valor do dado permanece inalterado no banco de dados"
end
