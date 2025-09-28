import { Suspense } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { EarnPointsTab } from "./earn-points-tab";
import { RewardsTab } from "./rewards-tab";
import { HistoryTab } from "./history-tab";

export default function RewardsPage() {
  return (
    <div className="container mx-auto p-6">
      <div className="mb-6">
        <h1 className="text-3xl font-bold">Rewards (Points)</h1>
        <p className="text-muted-foreground">
          Earn points by scanning cases and redeem them for rewards
        </p>
      </div>

      <Tabs defaultValue="earn" className="space-y-6">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="earn">Earn Points</TabsTrigger>
          <TabsTrigger value="rewards">Rewards</TabsTrigger>
          <TabsTrigger value="history">History</TabsTrigger>
        </TabsList>

        <TabsContent value="earn">
          <Suspense fallback={<div>Loading...</div>}>
            <EarnPointsTab />
          </Suspense>
        </TabsContent>

        <TabsContent value="rewards">
          <Suspense fallback={<div>Loading...</div>}>
            <RewardsTab />
          </Suspense>
        </TabsContent>

        <TabsContent value="history">
          <Suspense fallback={<div>Loading...</div>}>
            <HistoryTab />
          </Suspense>
        </TabsContent>
      </Tabs>
    </div>
  );
}