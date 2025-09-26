
"use client";
import { LogOut } from "lucide-react";
import { useTransition } from "react";

export default function Header({ onSignOut }: { onSignOut: () => void }) {
  const [pending, start] = useTransition();
  return (
    <header className="w-full border-b border-border px-4 py-2 flex items-center justify-between">
      <div className="font-semibold">Serapod2u</div>
      <button
        onClick={() => start(onSignOut)}
        className="inline-flex items-center gap-2 px-3 py-1.5 rounded-lg border border-border text-sm"
        aria-label="Sign Out"
        title="Sign Out"
      >
        <LogOut className="h-4 w-4" />
        {pending ? "Signing out..." : "Sign Out"}
      </button>
    </header>
  );
}
