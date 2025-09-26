"use client";

import { useState, useEffect } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { createClient } from "@/lib/supabase/client";
import ListTab from "./components/tabs/ListTab";
import DetailsTab from "./components/tabs/DetailsTab";
import { Factory } from "lucide-react";

interface Manufacturer {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  address?: string;
  logo_url?: string;
  created_at: string;
  updated_at?: string;
}

interface ManufacturersPageProps {
  manufacturers: Manufacturer[];
  currentUserRole: string;
}

function ManufacturersPageClient({ manufacturers, currentUserRole }: ManufacturersPageProps) {
  const [selectedManufacturerId, setSelectedManufacturerId] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState("list");
  const [selectedManufacturer, setSelectedManufacturer] = useState<Manufacturer | null>(null);

  const canEdit = currentUserRole === "hq_admin" || currentUserRole === "power_user";

  useEffect(() => {
    if (selectedManufacturerId) {
      const manufacturer = manufacturers.find(m => m.id === selectedManufacturerId);
      setSelectedManufacturer(manufacturer || null);
      setActiveTab("details");
    }
  }, [selectedManufacturerId, manufacturers]);

  return (
    <div className="min-h-screen bg-white">
      <div className="mx-auto max-w-7xl space-y-8 py-6 px-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Manufacturers</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Manage manufacturer information and details
          </p>
        </div>

        <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
          <TabsList className="grid w-full grid-cols-2 bg-white border border-gray-200">
            <TabsTrigger value="list" className="flex items-center space-x-2 data-[state=active]:bg-white data-[state=active]:border data-[state=active]:border-gray-300 data-[state=active]:shadow-sm">
              <Factory className="h-4 w-4" />
              <span>List</span>
            </TabsTrigger>
            <TabsTrigger value="details" className="flex items-center space-x-2 data-[state=active]:bg-white data-[state=active]:border data-[state=active]:border-gray-300 data-[state=active]:shadow-sm">
              <Factory className="h-4 w-4" />
              <span>Details</span>
            </TabsTrigger>
          </TabsList>

          <TabsContent value="list">
            <ListTab
              manufacturers={manufacturers}
              onSelectManufacturer={setSelectedManufacturerId}
            />
          </TabsContent>

          <TabsContent value="details">
            <DetailsTab
              manufacturer={selectedManufacturer}
              canEdit={canEdit}
            />
          </TabsContent>
        </Tabs>
      </div>
    </div>
  );
}

export default async function ManufacturersPage() {
  const supabase = createClient();

  // Get current user role
  const { data: { user } } = await supabase.auth.getUser();
  const { data: profile } = await supabase
    .from("users_profile")
    .select("role")
    .eq("user_id", user?.id)
    .single();

  // Fetch manufacturers
  const { data: manufacturers = [] } = await supabase
    .from("manufacturers")
    .select("*")
    .order("name");

  return (
    <ManufacturersPageClient
      manufacturers={manufacturers || []}
      currentUserRole={profile?.role || "shop"}
    />
  );
}