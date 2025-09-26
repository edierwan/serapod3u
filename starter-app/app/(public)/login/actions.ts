
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

// Individual server actions for each role
export async function devFastLoginHqAdmin() {
  return devFastLogin("hq_admin");
}

export async function devFastLoginPowerUser() {
  return devFastLogin("power_user");
}

export async function devFastLoginManufacturer() {
  return devFastLogin("manufacturer");
}

export async function devFastLoginWarehouse() {
  return devFastLogin("warehouse");
}

export async function devFastLoginDistributor() {
  return devFastLogin("distributor");
}

export async function devFastLoginShop() {
  return devFastLogin("shop");
}

export async function devFastLogin(role_code: string) {
  if (process.env.NODE_ENV === "production" || process.env.NEXT_PUBLIC_ENABLE_FAST_LOGIN !== "true") {
    throw new Error("Fast Login disabled");
  }

  const svc = createServiceClient();
  const ssr = createSSRClient();

  try {
    // Find matching dev email from table
    const { data: acct, error: acctErr } = await svc
      .from("dev_fastlogin_accounts")
      .select("*")
      .eq("role_code", role_code)
      .limit(1)
      .maybeSingle();

    if (acctErr || !acct) {
      console.error(`No dev account for role ${role_code}:`, acctErr);
      throw new Error("No dev account for role");
    }

    const email = acct.email as string;
    const password = "dev123456";

    // Get existing user and reset password to ensure it matches
    const { data: userList } = await svc.auth.admin.listUsers();
    const existing = userList?.users?.find(user => user.email === email);
    
    if (existing) {
      // Reset password to ensure it matches what we expect
      await svc.auth.admin.updateUserById(existing.id, {
        password,
        user_metadata: { role_code }
      });
      
      // Ensure profile exists
      await svc.from("profiles").upsert({
        id: existing.id,
        role_code,
        full_name: acct.full_name ?? null,
      }, { onConflict: "id" });
    } else {
      // Create new user
      const { data: newUser, error: createError } = await svc.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: { role_code }
      });
      
      if (createError) {
        console.error(`Failed to create user for ${email}:`, createError);
        throw new Error(`Failed to create user: ${createError.message}`);
      }
      
      // Create profile for new user
      if (newUser.user) {
        await svc.from("profiles").upsert({
          id: newUser.user.id,
          role_code,
          full_name: acct.full_name ?? null,
        }, { onConflict: "id" });
      }
    }

    // Now try to sign in
    const { data: signInResult, error: signInError } = await ssr.auth.signInWithPassword({ email, password });

    if (signInError) {
      console.error(`Sign in failed for ${email}:`, signInError);
      throw new Error(`Sign in failed: ${signInError.message}`);
    }

    if (!signInResult?.user) {
      throw new Error("Sign in succeeded but no user returned");
    }

  } catch (error) {
    console.error('Fast login error:', error);
    throw new Error(`Fast login failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }

  redirect("/dashboard");
}

export async function logoutAction() {
  const supabase = createSSRClient();
  await supabase.auth.signOut();
  redirect("/login");
}
