
import { LogOut } from "lucide-react";

export default function SettingsPage(){
  return (
    <div className="space-y-6">
      <h1 className="text-xl font-semibold">Settings</h1>
      <div className="space-y-3">
        <div className="text-sm text-muted-foreground">Profile</div>
        <div className="rounded-lg border border-border p-3">TODO</div>
      </div>
      <div className="space-y-3">
        <div className="text-sm text-muted-foreground">Preferences</div>
        <div className="rounded-lg border border-border p-3">TODO</div>
      </div>
      <div className="space-y-3">
        <div className="text-sm text-muted-foreground">Danger Zone (admins only)</div>
        <div className="rounded-lg border border-border p-3 opacity-60 pointer-events-none">Disabled placeholders in Phase 1</div>
      </div>
      <div className="space-y-2">
        <div className="text-sm text-muted-foreground">Sign Out</div>
        <button className="inline-flex items-center gap-2 px-3 py-2 rounded-lg border border-border">
          <LogOut className="w-4 h-4" /> Sign Out
        </button>
      </div>
    </div>
  )
}
