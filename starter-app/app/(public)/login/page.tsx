
import { 
  loginAction, 
  devFastLoginHqAdmin,
  devFastLoginPowerUser,
  devFastLoginManufacturer,
  devFastLoginWarehouse,
  devFastLoginDistributor,
  devFastLoginShop
} from "./actions";
import { Button } from "@/components/ui/button";

export default function LoginPage() {
  const dev = process.env.NEXT_PUBLIC_ENABLE_FAST_LOGIN === "true" && process.env.NODE_ENV !== "production";

  const fastLoginActions = {
    hq_admin: devFastLoginHqAdmin,
    power_user: devFastLoginPowerUser,
    manufacturer: devFastLoginManufacturer,
    warehouse: devFastLoginWarehouse,
    distributor: devFastLoginDistributor,
    shop: devFastLoginShop,
  };

  return (
    <div className="min-h-screen grid place-items-center bg-white">
      <div className="w-full max-w-sm border border-border rounded-xl p-4 space-y-4 bg-white shadow-sm">
        <h1 className="text-lg font-semibold">Sign in</h1>
        <form action={loginAction} className="space-y-3">
          <input className="w-full border border-border rounded-lg px-3 py-2 bg-white" type="email" name="email" placeholder="Email" required />
          <input className="w-full border border-border rounded-lg px-3 py-2 bg-white" type="password" name="password" placeholder="Password" required />
          <Button type="submit" variant="outline" className="w-full">
            Sign in
          </Button>
        </form>

        {dev && (
          <div className="pt-2 space-y-2">
            <div className="text-sm text-muted-foreground">Fast Login (dev)</div>
            <div className="grid grid-cols-2 gap-2">
              {(Object.keys(fastLoginActions) as Array<keyof typeof fastLoginActions>).map((role) => (
                <form key={role} action={fastLoginActions[role]}>
                  <Button type="submit" variant="outline" size="sm" className="w-full">
                    {role}
                  </Button>
                </form>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
