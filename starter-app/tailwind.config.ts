
import type { Config } from "tailwindcss";

export default {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        background: "rgb(var(--background))",
        foreground: "rgb(var(--foreground))",
        card: "rgb(var(--card))",
        muted: "rgb(var(--muted))",
        "muted-foreground": "rgb(var(--muted-foreground))",
        primary: "rgb(var(--primary))",
        border: "rgb(var(--border))",
        success: "rgb(var(--success))",
        warning: "rgb(var(--warning))",
        info: "rgb(var(--info))",
        neutral: "rgb(var(--neutral))",
      },
    },
  },
  plugins: [],
} satisfies Config;
