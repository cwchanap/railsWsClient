import { describe, test, expect, beforeEach } from "bun:test"
import { Application } from "@hotwired/stimulus"
import HelloController from "../../controllers/hello_controller"

describe("HelloController", () => {
  let application: Application
  let element: HTMLDivElement

  beforeEach(() => {
    // Set up DOM element
    element = document.createElement("div")
    element.dataset.controller = "hello"
    document.body.appendChild(element)

    // Initialize Stimulus application
    application = Application.start()
    application.register("hello", HelloController)
  })

  test("sets element text content on connect", () => {
    expect(element.textContent).toBe("Hello World!")
  })

  test("controller is properly registered", () => {
    const controllerName = application.router.modulesByIdentifier.get("hello")
    expect(controllerName).toBeDefined()
  })
})
