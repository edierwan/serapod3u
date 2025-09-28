import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Coins, Gift, ArrowUpDown } from "lucide-react";

async function getRewardsHistory() {
  const res = await fetch(`${process.env.NEXT_PUBLIC_APP_URL}/api/rewards/summary`, {
    cache: 'no-store'
  });
  if (!res.ok) throw new Error('Failed to fetch history');
  return res.json();
}

export async function HistoryTab() {
  const summaryRes = await getRewardsHistory();

  if (!summaryRes.ok) {
    return <div>Error loading history</div>;
  }

  const summary = summaryRes.data;

  return (
    <div className="space-y-6">
      {/* Transaction History */}
      <Card>
        <CardHeader>
          <CardTitle>Transaction History</CardTitle>
          <CardDescription>Your complete points transaction history</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {summary.recent_transactions?.length > 0 ? (
              summary.recent_transactions.map((tx: any) => (
                <div key={tx.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="flex items-center space-x-4">
                    <div className={`flex items-center justify-center w-10 h-10 rounded-full ${
                      tx.points > 0 ? 'bg-green-100' : 'bg-red-100'
                    }`}>
                      {tx.points > 0 ? (
                        <Coins className="h-5 w-5 text-green-600" />
                      ) : tx.source === 'redeem' ? (
                        <Gift className="h-5 w-5 text-red-600" />
                      ) : (
                        <ArrowUpDown className="h-5 w-5 text-red-600" />
                      )}
                    </div>
                    <div>
                      <p className="font-medium">
                        {tx.points > 0 ? '+' : ''}{tx.points} points
                      </p>
                      <p className="text-sm text-muted-foreground">
                        {tx.source.replace('_', ' ')} • {tx.reference_id}
                        {tx.products?.name && ` • ${tx.products.name}`}
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <Badge variant={tx.points > 0 ? "default" : "destructive"}>
                      {tx.points > 0 ? "Earned" : "Spent"}
                    </Badge>
                    <p className="text-xs text-muted-foreground mt-1">
                      {new Date(tx.created_at).toLocaleDateString()}
                    </p>
                  </div>
                </div>
              ))
            ) : (
              <p className="text-center text-muted-foreground py-8">
                No transactions yet.
              </p>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Redemption History - Placeholder for now */}
      <Card>
        <CardHeader>
          <CardTitle>Redemption History</CardTitle>
          <CardDescription>Items you&apos;ve redeemed</CardDescription>
        </CardHeader>
        <CardContent>
          <p className="text-center text-muted-foreground py-8">
            No redemptions yet. Redeem rewards to see them here!
          </p>
        </CardContent>
      </Card>
    </div>
  );
}