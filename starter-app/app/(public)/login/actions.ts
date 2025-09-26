
"use server";

import { createSSRClient } from "@/lib/supabase/server";
import { createServiceClient } from "@/lib/supabase/service";
import { redirect } from "next/navigation";

export async function loginAction(formData: FormData) {
  const email = String(formData.get("email") || "");
  const password = String(formData.get("password") || "");
  const supabase = createSSRClient();
  const { error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) {
    // avoid leaking exact reason to UI
    throw new Error("Login failed");
  }
  redirect("/dashboard");
}

export async function devFastLogin(role_code: string) {
  if (process.env.NODE_ENV === "production" || process.env.NEXT_PUBLIC_ENABLE_FAST_LOGIN !== "true") {
    throw new Error("Fast Login disabled");
  }

  const svc = createServiceClient();
  const ssr = createSSRClient();

  // Find matching dev email from table
  const { data: acct, error: acctErr } = await svc
    .from("dev_fastlogin_accounts")
    .select("*")
    .eq("role_code", role_code)
    .limit(1)
    .maybeSingle();

  if (acctErr || !acct) throw new Error("No dev account for role");

  const email = acct.email as string;
  const password = "dev123456";

  // Ensure auth user exists
  const { data: existing } = await svc.auth.admin.getUserByEmail(email);
  if (!existing?.user) {
    await svc.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { role_code }
    });
  }

  // Ensure profile exists/updated
  await svc.from("profiles").upsert({
    id: existing?.user?.id ?? null,
    role_code,
    full_name: acct.full_name ?? null,
  }, { onConflict: "id" });

  // Sign in via SSR cookies
  const { error } = await ssr.auth.signInWithPassword({ email, password });
  if (error) throw new Error("Fast login failed");

  redirect("/dashboard");
}

export async function logoutAction() {
  const supabase = createSSRClient();
  await supabase.auth.signOut();
  redirect("/login");
}
