Given('que estou autenticado como administrador no sistema para visualizar resultados') do
    pending "Implementar autenticação como administrador no sistema"
  end
  
  Given('que estou na página inicial do sistema') do
    pending "Implementar navegação para a página inicial"
  end
  
  When('eu clico no ícone de menu') do
    pending "Implementar clique no ícone de menu"
  end
  
  When('eu clico no botão {string}') do |botao|
    pending "Implementar clique no botão '#{botao}'"
  end
  
  Then('devo ser redirecionado para a página de enviar formulários') do
    pending "Implementar redirecionamento para a página de envio de formulários"
  end
  
  Then('devo ver os filtros {string} e {string}') do |filtro1, filtro2|
    pending "Implementar verificação da presença dos filtros '#{filtro1}' e '#{filtro2}'"
  end
  
  Given('que estou na página de enviar formulários') do
    pending # Write code here that turns the phrase above into concrete actions
  end
  
  When('eu seleciono {string} no filtro {string}') do |valor, filtro|
    pending "Implementar seleção do valor '#{valor}' no filtro '#{filtro}'"
  end
  
  When('eu clico no botão {string}') do |botao|
    pending "Implementar clique no botão '#{botao}'"
  end
  
  Then('devo ver os resultados de {string} semestre {string}') do |departamento, semestre|
    pending "Implementar exibição dos resultados para '#{departamento}' no semestre '#{semestre}'"
  end
  
  Then('devo ver uma mensagem de erro {string}') do |mensagem|
    pending "Implementar exibição da mensagem de erro '#{mensagem}'"
  end
  
  Then('devo ser redirecionado de volta à página inicial') do
    pending "Implementar redirecionamento para a página inicial em caso de erro"
  end
  
  Then('a tabela de resultados deve estar vazia') do
    pending "Implementar verificação de tabela de resultados vazia"
  end
  