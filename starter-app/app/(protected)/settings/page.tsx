
import { LogOut } from "lucide-react";
import { Button } from "@/components/ui/button";

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
        <Button variant="secondary">
          <LogOut className="w-4 h-4 mr-2" /> Sign Out
        </Button>
      </div>
    </div>
  )
}
