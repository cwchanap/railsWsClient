import { describe, test, expect } from "bun:test"
import { application } from "../controllers/application"

describe("Stimulus Application", () => {
  test("application is defined", () => {
    expect(application).toBeDefined()
  })

  test("application debug mode is disabled", () => {
    expect(application.debug).toBe(false)
  })

  test("Stimulus is attached to window", () => {
    expect(window.Stimulus).toBeDefined()
    expect(window.Stimulus).toBe(application)
  })
})
