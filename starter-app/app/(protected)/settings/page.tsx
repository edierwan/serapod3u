
import { LogOut } from "lucide-react";
import { Button } from "@/components/ui/button";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import { DangerZone } from "./danger-zone";

export default async function SettingsPage() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  // Load profile to check role
  const { data: profile } = await supabase
    .from("profiles")
    .select("role_code")
    .eq("id", user.id)
    .maybeSingle();

  const isAdmin = profile?.role_code === "hq_admin" || profile?.role_code === "power_user";

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
      {isAdmin && (
        <div className="space-y-3">
          <div className="text-sm text-muted-foreground">Danger Zone (admins only)</div>
          <DangerZone />
        </div>
      )}
      <div className="space-y-2">
        <div className="text-sm text-muted-foreground">Sign Out</div>
        <Button variant="secondary">
          <LogOut className="w-4 h-4 mr-2" /> Sign Out
        </Button>
      </div>
    </div>
  );
}
