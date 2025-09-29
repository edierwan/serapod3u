"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import ManufacturerCardView from "@/components/manufacturers/ManufacturerCardView";
import ManufacturerFormModal from "@/components/products/ManufacturerFormModal";
import DetailsTab from "./components/tabs/DetailsTab";
import { createClient } from "@/lib/supabase/client";
import { toast } from "sonner";

interface Manufacturer {
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

interface ManufacturersPageClientProps {
  manufacturers: Manufacturer[];
  categories: Category[];
  currentUserRole: string;
}

export default function ManufacturersPageClient({ 
  manufacturers: initialManufacturers, 
  categories,
  currentUserRole 
}: ManufacturersPageClientProps) {
  const [manufacturers, setManufacturers] = useState(initialManufacturers);
  const [selectedManufacturer, setSelectedManufacturer] = useState<Manufacturer | null>(null);
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [isDetailsModalOpen, setIsDetailsModalOpen] = useState(false);
  const [editingManufacturer, setEditingManufacturer] = useState<Manufacturer | null>(null);
  const [deletingManufacturer, setDeletingManufacturer] = useState<Manufacturer | null>(null);

  const canEdit = currentUserRole === "hq_admin" || currentUserRole === "power_user";

  // Refresh manufacturers list when needed
  const refreshManufacturers = async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("manufacturers")
      .select(`
        id, name, is_active, logo_url, contact_person, phone, email, website_url, 
        address_line1, address_line2, city, state_region, postal_code, country_code, 
        language_code, currency_code, tax_id, registration_number, 
        support_email, support_phone, timezone, notes, created_at, updated_at,
        category:categories(id, name)
      `)
      .order("name", { ascending: true });
    
    if (data) {
      // Get product counts for each manufacturer
      const manufacturerIds = data.map(m => m.id);
      const { data: productCountsData } = await supabase
        .from("products")
        .select("manufacturer_id")
        .in("manufacturer_id", manufacturerIds);

      const productCounts = productCountsData || [];
      const productCountsMap = productCounts.reduce((acc, product) => {
        if (product.manufacturer_id) {
          acc[product.manufacturer_id] = (acc[product.manufacturer_id] || 0) + 1;
        }
        return acc;
      }, {} as Record<string, number>);

      const manufacturersWithMetrics = data.map(manufacturer => ({
        ...manufacturer,
        category: Array.isArray(manufacturer.category) ? manufacturer.category[0] : manufacturer.category,
        products_count: productCountsMap[manufacturer.id] || 0,
        orders_count: 0 // Placeholder
      }));

      setManufacturers(manufacturersWithMetrics);
    }
  };

  // Listen for manufacturer updates
  useEffect(() => {
    const supabase = createClient();
    
    const channel = supabase
      .channel('manufacturers_changes')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'manufacturers'
      }, () => {
        refreshManufacturers();
      })
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, []);

  const handleAdd = () => {
    console.log("Add button clicked");
    setEditingManufacturer(null);
    setIsFormModalOpen(true);
  };

  const handleEdit = (manufacturer: Manufacturer) => {
    setEditingManufacturer(manufacturer);
    setIsFormModalOpen(true);
  };

  const handleView = (manufacturer: Manufacturer) => {
    setSelectedManufacturer(manufacturer);
    setIsDetailsModalOpen(true);
  };

  const handleDelete = (manufacturer: Manufacturer) => {
    setDeletingManufacturer(manufacturer);
  };

  const confirmDelete = async () => {
    if (!deletingManufacturer) return;

    try {
      // Use the server action for deletion
      const result = await fetch('/api/manufacturers/delete', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id: deletingManufacturer.id }),
      });

      const data = await result.json();

      if (data.success) {
        toast.success("Manufacturer deleted successfully");
        refreshManufacturers();
      } else {
        toast.error(data.error || "Failed to delete manufacturer");
      }
    } catch {
      toast.error("Delete failed");
    } finally {
      setDeletingManufacturer(null);
    }
  };

  const handleFormClose = () => {
    setIsFormModalOpen(false);
    setEditingManufacturer(null);
    refreshManufacturers();
  };

  console.log("Modal open state:", isFormModalOpen);

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="mx-auto max-w-7xl py-6 px-4">
        <ManufacturerCardView
          manufacturers={manufacturers}
          categories={categories}
          onAdd={handleAdd}
          onEdit={handleEdit}
          onView={handleView}
          onLogoUpdate={refreshManufacturers}
          onDelete={handleDelete}
        />

        {/* Add/Edit Modal */}
        <ManufacturerFormModal
          open={isFormModalOpen}
          onOpenChange={(open) => {
            console.log("Modal onOpenChange:", open);
            setIsFormModalOpen(open);
          }}
          manufacturer={editingManufacturer || undefined}
          categories={categories}
          onSuccess={handleFormClose}
        />

        {/* Details Modal */}
        <Dialog open={isDetailsModalOpen} onOpenChange={setIsDetailsModalOpen}>
          <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>
                Manufacturer Details - {selectedManufacturer?.name}
              </DialogTitle>
            </DialogHeader>
            {selectedManufacturer && (
              <DetailsTab
                manufacturer={selectedManufacturer}
                canEdit={canEdit}
                onRefresh={refreshManufacturers}
                categories={categories}
              />
            )}
          </DialogContent>
        </Dialog>

        {/* Delete Confirmation Modal */}
        <Dialog open={!!deletingManufacturer} onOpenChange={() => setDeletingManufacturer(null)}>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Delete manufacturer?</DialogTitle>
            </DialogHeader>
            <p className="text-sm text-muted-foreground">
              This will permanently delete <strong>{deletingManufacturer?.name}</strong>. You can&apos;t undo this.
            </p>
            <DialogFooter>
              <Button variant="outline" onClick={() => setDeletingManufacturer(null)}>
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
