Given("que eu sou um administrador autenticado no sistema") do
  pending "Implementar lógica para autenticar o administrador no sistema"
end

Given("eu tenho um arquivo válido contendo os dados de novos participantes exportados do SIGAA") do
  pending "Implementar lógica para verificar a existência de um arquivo válido"
end

When('eu acesso a funcionalidade de "Importar Participantes"') do
  pending "Implementar lógica para navegar até a funcionalidade de importação"
end

When("faço o upload do arquivo com os dados") do
  pending "Implementar lógica para realizar o upload do arquivo"
end

Then("o sistema processa os dados") do
  pending "Implementar lógica para verificar se os dados foram processados"
end

Then("envia um e-mail para cada participante com um link para definir sua senha") do
  pending "Implementar lógica para verificar o envio de e-mails com links"
end

Then("os participantes aparecem na lista de usuários pendentes") do
  pending "Implementar lógica para verificar a exibição dos participantes pendentes"
end

When("faço o upload de um arquivo inválido") do
  pending "Implementar lógica para realizar o upload de um arquivo inválido"
end

Then("o sistema exibe uma mensagem de erro informando o motivo da falha") do |mensagem|
  pending "Implementar lógica para verificar a mensagem de erro exibida: #{mensagem}"
end

Then("nenhum participante é cadastrado no sistema") do
  pending "Implementar lógica para garantir que nenhum participante foi cadastrado"
end
