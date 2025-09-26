
import { ReactNode } from "react";
import { createSSRClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import Header from "@/components/layout/Header";
import Sidebar from "@/components/layout/Sidebar";
import { SidebarByRole } from "@/lib/rbac";
import { logoutAction } from "../(public)/login/actions";

export default async function ProtectedLayout({ children }: { children: ReactNode }) {
  const supabase = createSSRClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Load profile (role)
  const { data: profile } = await supabase.from("profiles").select("role_code, full_name, avatar_url").eq("id", user.id).maybeSingle();
  const role = (profile?.role_code ?? "shop") as keyof typeof SidebarByRole;
  const items = SidebarByRole[role];

  return (
    <div className="min-h-screen grid grid-rows-[auto_1fr] bg-white">
      <Header onSignOut={async () => { "use server"; await logoutAction(); }} />
      <div className="grid grid-cols-[16rem_1fr] bg-white">
        <Sidebar items={items} />
        <main className="p-4 bg-white">{children}</main>
      </div>
    </div>
  );
}
