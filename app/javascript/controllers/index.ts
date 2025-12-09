// Import and register all your controllers
import { application } from "./application"

// Eager load all controllers
import HelloController from "./hello_controller"
application.register("hello", HelloController)

export { application }
