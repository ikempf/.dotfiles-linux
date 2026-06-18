import type { Plugin } from "@opencode-ai/plugin"

const BELL = `${process.env.HOME}/dotfiles/scripts/tmux-bell.sh`

export const BellPlugin: Plugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (
        event.type === "session.idle" ||
        event.type === "permission.asked" ||
        event.type === "question.asked"
      ) {
        await $`${BELL}`.nothrow()
      }
    },
  }
}