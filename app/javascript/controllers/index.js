// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)


// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

// import { definitionsFromContext } from "stimulus/webpack-helpers"

// const context = require.context("controllers", true, /_controller\.js$/)
// application.load(definitionsFromContext(context))
