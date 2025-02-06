Given("que eu estou autenticado no sistema") do
  pending "Implementar lógica para autenticar o usuário no sistema"
end

Given("estou matriculado em uma ou mais turmas") do |turmas|
  pending "Implementar lógica para verificar as turmas do usuário: #{turmas}"
end

Given("existem formulários não respondidos nas turmas em que estou matriculado") do |formulario|
  pending "Implementar lógica para verificar os formulários pendentes: #{formulario}"
end

When('eu acesso a página de "Formulários Não Respondidos"') do
  pending "Implementar lógica para acessar a página de formulários não respondidos"
end

Then("eu vejo uma lista com os formulários pendentes") do |lista_formularios|
  pending "Implementar lógica para verificar a lista de formulários pendentes: #{lista_formularios}"
end

Then("cada formulário exibe o nome da turma e o título do formulário") do |nome_turma, titulo_formulario|
  pending "Implementar lógica para verificar detalhes do formulário: #{nome_turma} - #{titulo_formulario}"
end

Then("há um botão ou link para responder a cada formulário") do |botao_responder|
  pending "Implementar lógica para verificar o botão de resposta: #{botao_responder}"
end

Given("não existem formulários não respondidos nas turmas em que estou matriculado") do
  pending "Implementar lógica para verificar a ausência de formulários pendentes"
end

Then("eu vejo uma mensagem indicando que não há formulários pendentes para responder") do |mensagem|
  pending "Implementar lógica para verificar a mensagem exibida: #{mensagem}"
end

Given("eu não estou matriculado em nenhuma turma") do
  pending "Implementar lógica para verificar a ausência de matrícula"
end

Then("eu vejo uma mensagem indicando que não estou matriculado em nenhuma turma") do |mensagem|
  pending "Implementar lógica para verificar a mensagem exibida: #{mensagem}"
end

When("ocorre um erro ao carregar os formulários") do
  pending "Implementar lógica para simular o erro ao carregar formulários"
end

Then("eu vejo uma mensagem de erro indicando que houve um problema ao carregar os formulários") do |mensagem|
  pending "Implementar lógica para verificar a mensagem de erro exibida: #{mensagem}"
end
