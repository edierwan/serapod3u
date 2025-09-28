import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Coins, TrendingUp, Calendar, Target } from "lucide-react";

async function getRewardsSummary() {
  const res = await fetch(`${process.env.NEXT_PUBLIC_APP_URL}/api/rewards/summary`, {
    cache: 'no-store'
  });
  if (!res.ok) throw new Error('Failed to fetch summary');
  return res.json();
}

async function getEarnData() {
  const res = await fetch(`${process.env.NEXT_PUBLIC_APP_URL}/api/rewards/earn`, {
    cache: 'no-store'
  });
  if (!res.ok) throw new Error('Failed to fetch earn data');
  return res.json();
}

export async function EarnPointsTab() {
  const [summaryRes, earnRes] = await Promise.all([
    getRewardsSummary(),
    getEarnData()
  ]);

  if (!summaryRes.ok || !earnRes.ok) {
    return <div>Error loading data</div>;
  }

  const summary = summaryRes.data;
  const earnData = earnRes.data;

  return (
    <div className="space-y-6">
      {/* Balance and Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Current Balance</CardTitle>
            <Coins className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{summary.current_balance}</div>
            <p className="text-xs text-muted-foreground">points available</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Current Level</CardTitle>
            <Target className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">Level {summary.level}</div>
            <p className="text-xs text-muted-foreground">
              {summary.next_level_threshold - summary.total_earned} points to next level
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">This Month</CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">+{summary.monthly_earned}</div>
            <p className="text-xs text-muted-foreground text-red-600">-{summary.monthly_redeemed} redeemed</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Earned</CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{summary.total_earned}</div>
            <p className="text-xs text-muted-foreground">{summary.total_transactions} transactions</p>
          </CardContent>
        </Card>
      </div>

      {/* Recent Earns */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Points Earned</CardTitle>
          <CardDescription>Your latest point-earning activities</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {earnData.recent_earns?.length > 0 ? (
              earnData.recent_earns.map((earn: any) => (
                <div key={earn.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="flex items-center space-x-4">
                    <div className="flex items-center justify-center w-10 h-10 bg-green-100 rounded-full">
                      <Coins className="h-5 w-5 text-green-600" />
                    </div>
                    <div>
                      <p className="font-medium">
                        +{earn.points} points from {earn.source.replace('_', ' ')}
                      </p>
                      <p className="text-sm text-muted-foreground">
                        {earn.products?.name || 'Unknown product'} • {earn.reference_id}
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <Badge variant="secondary">Earned</Badge>
                    <p className="text-xs text-muted-foreground mt-1">
                      {new Date(earn.created_at).toLocaleDateString()}
                    </p>
                  </div>
                </div>
              ))
            ) : (
              <p className="text-center text-muted-foreground py-8">
                No points earned yet. Start scanning cases to earn points!
              </p>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Available Activities */}
      {earnData.available_activities?.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle>Available Activities</CardTitle>
            <CardDescription>Complete these activities to earn extra points</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {earnData.available_activities.map((activity: any) => (
                <div key={activity.id} className="p-4 border rounded-lg">
                  <h3 className="font-medium">{activity.name}</h3>
                  <p className="text-sm text-muted-foreground mb-2">{activity.description}</p>
                  <div className="flex items-center justify-between">
                    <Badge variant="outline">+{activity.points_reward} points</Badge>
                    <span className="text-xs text-muted-foreground">
                      Completed: {activity.progress.completions_count}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}