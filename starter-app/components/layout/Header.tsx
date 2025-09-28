
"use client";
import { LogOut } from "lucide-react";
import { useTransition } from "react";
import { Button } from "@/components/ui/button";
import type { User } from "@supabase/supabase-js";

interface Profile {
  role_code: string;
  full_name?: string;
}

export default function Header({ 
  onSignOut, 
  user, 
  profile 
}: { 
  onSignOut: () => void;
  user: User | null;
  profile: Profile | null;
}) {
  const [pending, start] = useTransition();
  
  let displayText = "";

  if (user) {
    const fullName = profile?.full_name;
    const role = profile?.role_code ?? null;
    
    // Don't use full_name if it looks like a role (to prevent duplication)
    const roleValues = ['HQ Admin', 'Power User', 'Manufacturer', 'Warehouse', 'Distributor', 'Shop User'];
    
    if (fullName && !roleValues.includes(fullName)) {
      // Use full_name if it's meaningful
      displayText = fullName;
    } else if (role) {
      // Use role label if no meaningful full_name
      displayText = ({
        hq_admin: "HQ Admin",
        power_user: "Power User",
        manufacturer: "Manufacturer",
        warehouse: "Warehouse",
        distributor: "Distributor",
        shop: "Shop User",
      } as const)[role] ?? (role.charAt(0).toUpperCase() + role.slice(1));
    } else {
      // Fallback to email
      displayText = user.email ?? "";
    }
  }
  
  return (
    <header className="w-full border-b border-border px-4 py-2 flex items-center justify-between">
      <div className="font-semibold">Serapod2u</div>
      <div className="flex flex-col items-end">
        <Button
          onClick={() => start(onSignOut)}
          variant="secondary"
          size="sm"
          aria-label="Sign Out"
          title="Sign Out"
        >
          <LogOut className="h-4 w-4" />
          {pending ? "Signing out..." : "Sign Out"}
        </Button>
        {displayText && (
          <div className="mt-1 text-sm text-muted-foreground">
            Logged in as: {displayText}
          </div>
        )}
      </div>
    </header>
  );
}
