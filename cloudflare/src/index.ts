import { Container, getContainer } from "@cloudflare/containers"
import { env } from "cloudflare:workers"

interface Env {
  RAILS_CONTAINER: DurableObjectNamespace<RailsContainer>
  DATABASE_URL: string
  SECRET_KEY_BASE: string
}

export class RailsContainer extends Container<Env> {
  defaultPort = 8080
  sleepAfter = "10m"

  envVars = {
    DATABASE_URL: env.DATABASE_URL,
    SECRET_KEY_BASE: env.SECRET_KEY_BASE,
  }

  override onStart(): void {
    console.log("Container started")
  }

  override onStop(): void {
    console.log("Container stopped")
  }

  override onError(error: unknown): void {
    console.error("Container error:", error)
  }
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    try {
      const container = getContainer(env.RAILS_CONTAINER)
      return await container.fetch(request)
    } catch (e) {
      console.error("Container error:", e)
      return new Response("Container error", { status: 502 })
    }
  },
}
