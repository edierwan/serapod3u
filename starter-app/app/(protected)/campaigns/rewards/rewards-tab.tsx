"use client";

import { useState, useEffect, useCallback } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Gift, Star, Search, Filter } from "lucide-react";
import Image from "next/image";

interface RewardItem {
  id: string;
  title: string;
  description: string;
  points_cost: number;
  category: string;
  image_url: string | null;
  is_featured: boolean;
}

export function RewardsTab() {
  const [rewards, setRewards] = useState<RewardItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [category, setCategory] = useState("");
  const [redeeming, setRedeeming] = useState<string | null>(null);

  const fetchRewards = useCallback(async () => {
    try {
      const params = new URLSearchParams();
      if (search) params.set("search", search);
      if (category) params.set("category", category);

      const res = await fetch(`/api/rewards/catalog?${params}`);
      if (res.ok) {
        const data = await res.json();
        setRewards(data.data || []);
      }
    } catch (error) {
      console.error("Failed to fetch rewards:", error);
    } finally {
      setLoading(false);
    }
  }, [search, category]);

  useEffect(() => {
    fetchRewards();
  }, [fetchRewards]);

  const handleRedeem = async (rewardId: string) => {
    setRedeeming(rewardId);
    try {
      const res = await fetch("/api/rewards/redeem", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ catalog_id: rewardId }),
      });

      if (res.ok) {
        alert("Reward redeemed successfully!");
        // Refresh balance/stats would be good here
        window.location.reload();
      } else {
        const error = await res.json();
        alert(`Failed to redeem: ${error.message}`);
      }
    } catch (error) {
      console.error("Redeem error:", error);
      alert("Failed to redeem reward");
    } finally {
      setRedeeming(null);
    }
  };

  const categories = [...new Set(rewards.map(r => r.category))];
  const featuredRewards = rewards.filter(r => r.is_featured);
  const regularRewards = rewards.filter(r => !r.is_featured);

  if (loading) {
    return <div className="text-center py-8">Loading rewards...</div>;
  }

  return (
    <div className="space-y-6">
      {/* Search and Filter */}
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search rewards..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-10"
          />
        </div>
        <Select value={category} onValueChange={setCategory}>
          <SelectTrigger className="w-full sm:w-48">
            <Filter className="h-4 w-4 mr-2" />
            <SelectValue placeholder="All categories" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="">All categories</SelectItem>
            {categories.map(cat => (
              <SelectItem key={cat} value={cat}>{cat}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* Featured Rewards */}
      {featuredRewards.length > 0 && (
        <div>
          <h2 className="text-xl font-semibold mb-4 flex items-center">
            <Star className="h-5 w-5 mr-2 text-yellow-500" />
            Featured Rewards
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {featuredRewards.map((reward) => (
              <RewardCard
                key={reward.id}
                reward={reward}
                onRedeem={handleRedeem}
                redeeming={redeeming === reward.id}
              />
            ))}
          </div>
        </div>
      )}

      {/* All Rewards */}
      <div>
        <h2 className="text-xl font-semibold mb-4">All Rewards</h2>
        {regularRewards.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {regularRewards.map((reward) => (
              <RewardCard
                key={reward.id}
                reward={reward}
                onRedeem={handleRedeem}
                redeeming={redeeming === reward.id}
              />
            ))}
          </div>
        ) : (
          <div className="text-center py-8 text-muted-foreground">
            No rewards available matching your criteria.
          </div>
        )}
      </div>
    </div>
  );
}

function RewardCard({
  reward,
  onRedeem,
  redeeming
}: {
  reward: RewardItem;
  onRedeem: (id: string) => void;
  redeeming: boolean;
}) {
  return (
    <Card className="overflow-hidden">
      <div className="aspect-video bg-muted relative">
        {reward.image_url ? (
          <Image
            src={reward.image_url}
            alt={reward.title}
            fill
            className="object-cover"
          />
        ) : (
          <div className="flex items-center justify-center h-full">
            <Gift className="h-12 w-12 text-muted-foreground" />
          </div>
        )}
        {reward.is_featured && (
          <Badge className="absolute top-2 left-2 bg-yellow-500">
            <Star className="h-3 w-3 mr-1" />
            Featured
          </Badge>
        )}
      </div>
      <CardHeader>
        <div className="flex items-start justify-between">
          <div>
            <CardTitle className="text-lg">{reward.title}</CardTitle>
            <CardDescription>{reward.description}</CardDescription>
          </div>
          <Badge variant="secondary">{reward.category}</Badge>
        </div>
      </CardHeader>
      <CardContent>
        <div className="flex items-center justify-between">
          <div className="text-2xl font-bold text-primary">
            {reward.points_cost} points
          </div>
          <Button
            onClick={() => onRedeem(reward.id)}
            disabled={redeeming}
          >
            {redeeming ? "Redeeming..." : "Redeem"}
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}