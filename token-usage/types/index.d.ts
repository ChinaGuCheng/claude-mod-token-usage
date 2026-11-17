export type Win = { used: number; resetsAt?: string }
export type Snap = {
  five: Win | null
  seven: Win | null
  usd: number | null
  tokIn: number
  tokOut: number
  tokCache: number
  // tokens/s of the latest long-enough main-loop request; the totals give the session average
  tps: number | null
  tpsOut: number
  tpsMs: number
}

declare module 'claude-code' {
  interface PluginState {
    'token-usage': { snap: Snap; tick: number; fold: boolean }
  }
}
