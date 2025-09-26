
import { loginAction, devFastLogin } from "./actions";

export default function LoginPage() {
  const dev = process.env.NEXT_PUBLIC_ENABLE_FAST_LOGIN === "true" && process.env.NODE_ENV !== "production";

  return (
    <div className="min-h-screen grid place-items-center">
      <div className="w-full max-w-sm border border-border rounded-xl p-4 space-y-4 bg-card">
        <h1 className="text-lg font-semibold">Sign in</h1>
        <form action={loginAction} className="space-y-3">
          <input className="w-full border border-border rounded-lg px-3 py-2" type="email" name="email" placeholder="Email" required />
          <input className="w-full border border-border rounded-lg px-3 py-2" type="password" name="password" placeholder="Password" required />
          <button className="w-full border border-border rounded-lg px-3 py-2">Sign in</button>
        </form>

        {dev && (
          <div className="pt-2 space-y-2">
            <div className="text-sm text-muted-foreground">Fast Login (dev)</div>
            <div className="grid grid-cols-2 gap-2">
              {['hq_admin','power_user','manufacturer','warehouse','distributor','shop'].map((r) => (
                <form key={r} action={async () => devFastLogin(r)}>
                  <button className="w-full border border-border rounded-lg px-3 py-2 text-sm">{r}</button>
                </form>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
