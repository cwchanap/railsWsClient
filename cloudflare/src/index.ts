import { Container, getContainer } from "@cloudflare/containers"
import { env } from "cloudflare:workers"

interface Env {
  RAILS_CONTAINER: DurableObjectNamespace<RailsContainer>
  DB: D1Database
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
    const url = new URL(request.url)

    if (url.pathname === "/up") {
      return new Response("OK", { status: 200 })
    }

    try {
      const container = getContainer(env.RAILS_CONTAINER)
      // Use the simple pattern from official docs - fetch handles start
      return await container.fetch(request)
    } catch (e) {
      const error = e instanceof Error ? e.message : String(e)
      return new Response(`Container error: ${error}`, { status: 502 })
    }
  },
}
