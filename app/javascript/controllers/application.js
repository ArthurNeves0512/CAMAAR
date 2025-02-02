import { Application } from "@hotwired/stimulus"

// Inicia a aplicação Stimulus
const application = Application.start()

// Configura o Stimulus para ambiente de desenvolvimento
application.debug = false
window.Stimulus = application

// Exporta a instância da aplicação para uso em outros lugares
export { application }

// Importa e registra todos os controllers dentro do diretório "controllers"
import { definitionsFromContext } from "stimulus-webpack-helpers"
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
