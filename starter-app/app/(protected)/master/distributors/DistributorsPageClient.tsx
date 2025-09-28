"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import DistributorCardView from "@/components/distributors/DistributorCardView";
import DistributorFormModal from "@/components/distributors/DistributorFormModal";
import DetailsTab from "./components/DetailsTab";
import { createClient } from "@/lib/supabase/client";
import { toast } from "sonner";

interface Distributor {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  contact_person?: string;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  postal_code?: string;
  country_code?: string;
  logo_url?: string;
  is_active?: boolean;
  products_count?: number;
  orders_count?: number;
  created_at: string;
  updated_at?: string;
  category?: { id: string; name: string } | null;
}

interface Category {
  id: string;
  name: string;
}

interface DistributorsPageClientProps {
  distributors: Distributor[];
  categories: Category[];
  currentUserRole: string;
  searchParams: { search?: string; category_id?: string; is_active?: string };
}

export default function DistributorsPageClient({
  distributors: initialDistributors,
  categories,
  currentUserRole
}: DistributorsPageClientProps) {
    const [distributors, setDistributors] = useState(initialDistributors);
  const [selectedDistributor, setSelectedDistributor] = useState<Distributor | null>(null);
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [isDetailsModalOpen, setIsDetailsModalOpen] = useState(false);
  const [editingDistributor, setEditingDistributor] = useState<Distributor | null>(null);
  const [deletingDistributor, setDeletingDistributor] = useState<Distributor | null>(null);

  const canEdit = currentUserRole === "hq_admin" || currentUserRole === "power_user";

  // Refresh distributors list when needed
  const refreshDistributors = async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("distributors")
      .select(`
        id, name, is_active, logo_url, contact_person, phone, email, whatsapp,
        address_line1, address_line2, city, state_region, postal_code, country_code,
        website_url, notes, created_at, updated_at,
        category:categories(id, name)
      `)
      .order("name", { ascending: true });
    
    if (data) {
      // Get shops counts for each distributor
      const distributorIds = data.map(d => d.id);
      const { data: shopsCountsData } = await supabase
        .from("shops")
        .select("distributor_id")
        .in("distributor_id", distributorIds);

      const shopsCounts = shopsCountsData || [];
      const shopsCountsMap = shopsCounts.reduce((acc, shop) => {
        if (shop.distributor_id) {
          acc[shop.distributor_id] = (acc[shop.distributor_id] || 0) + 1;
        }
        return acc;
      }, {} as Record<string, number>);

      const distributorsWithMetrics = data.map(distributor => ({
        ...distributor,
        category: Array.isArray(distributor.category) ? distributor.category[0] : distributor.category,
        shops_count: shopsCountsMap[distributor.id] || 0,
        orders_count: 0 // Placeholder
      }));

      setDistributors(distributorsWithMetrics);
    }
  };

  // Listen for distributor updates
  useEffect(() => {
    const supabase = createClient();
    
    const channel = supabase
      .channel('distributors_changes')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'distributors'
      }, () => {
        refreshDistributors();
      })
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const handleAdd = () => {
    console.log("Add button clicked");
    setEditingDistributor(null);
    setIsFormModalOpen(true);
  };

  const handleEdit = (distributor: Distributor) => {
    setEditingDistributor(distributor);
    setIsFormModalOpen(true);
  };

  const handleView = (distributor: Distributor) => {
    setSelectedDistributor(distributor);
    setIsDetailsModalOpen(true);
  };

  const handleDelete = (distributor: Distributor) => {
    setDeletingDistributor(distributor);
  };

  const confirmDelete = async () => {
    if (!deletingDistributor) return;

    try {
      // Check if distributor has shops
      const supabase = createClient();
      const { data: shops } = await supabase
        .from("shops")
        .select("id")
        .eq("distributor_id", deletingDistributor.id)
        .limit(1);

      if (shops && shops.length > 0) {
        toast.error(`Cannot delete. There are shops linked to this distributor.`);
        setDeletingDistributor(null);
        return;
      }

      const { error } = await supabase
        .from("distributors")
        .delete()
        .eq("id", deletingDistributor.id);

      if (error) {
        toast.error("Failed to delete distributor");
      } else {
        toast.success("Distributor deleted successfully");
        refreshDistributors();
      }
    } catch {
      toast.error("Delete failed");
    } finally {
      setDeletingDistributor(null);
    }
  };

  const handleFormClose = () => {
    setIsFormModalOpen(false);
    setEditingDistributor(null);
    refreshDistributors();
  };

  console.log("Modal open state:", isFormModalOpen);

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="mx-auto max-w-7xl py-6 px-4">
        <DistributorCardView
          distributors={distributors}
          categories={categories}
          onAdd={handleAdd}
          onEdit={handleEdit}
          onView={handleView}
          onLogoUpdate={refreshDistributors}
          onDelete={handleDelete}
        />

        {/* Add/Edit Modal */}
        <DistributorFormModal
          open={isFormModalOpen}
          onOpenChange={(open: boolean) => {
            console.log("Modal onOpenChange:", open);
            setIsFormModalOpen(open);
          }}
          distributor={editingDistributor || undefined}
          categories={categories}
          onSuccess={handleFormClose}
        />

        {/* Details Modal */}
        <Dialog open={isDetailsModalOpen} onOpenChange={setIsDetailsModalOpen}>
          <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>
                Distributor Details - {selectedDistributor?.name}
              </DialogTitle>
            </DialogHeader>
            {selectedDistributor && (
              <DetailsTab
                distributor={selectedDistributor}
                canEdit={canEdit}
                onRefresh={refreshDistributors}
                categories={categories}
              />
            )}
          </DialogContent>
        </Dialog>

        {/* Delete Confirmation Modal */}
        <Dialog open={!!deletingDistributor} onOpenChange={() => setDeletingDistributor(null)}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Delete distributor?</DialogTitle>
            </DialogHeader>
            <p className="text-sm text-muted-foreground">
              This will permanently delete <strong>{deletingDistributor?.name}</strong>. You can&apos;t undo this.
            </p>
            <DialogFooter>
              <Button variant="outline" onClick={() => setDeletingDistributor(null)}>
                Cancel
              </Button>
              <Button variant="destructive" onClick={confirmDelete}>
                Delete
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
    </div>
  );
}
