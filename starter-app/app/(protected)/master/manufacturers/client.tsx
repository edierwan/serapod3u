"use client";

import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import ManufacturerCardView from "@/components/manufacturers/ManufacturerCardView";
import ManufacturerFormModal from "@/components/products/ManufacturerFormModal";
import DetailsTab from "./components/tabs/DetailsTab";
import { createClient } from "@/lib/supabase/client";

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
}

interface ManufacturersPageClientProps {
  manufacturers: Manufacturer[];
  currentUserRole: string;
}

export default function ManufacturersPageClient({ 
  manufacturers: initialManufacturers, 
  currentUserRole 
}: ManufacturersPageClientProps) {
  const [manufacturers, setManufacturers] = useState(initialManufacturers);
  const [selectedManufacturer, setSelectedManufacturer] = useState<Manufacturer | null>(null);
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [isDetailsModalOpen, setIsDetailsModalOpen] = useState(false);
  const [editingManufacturer, setEditingManufacturer] = useState<Manufacturer | null>(null);

  const canEdit = currentUserRole === "hq_admin" || currentUserRole === "power_user";

  // Refresh manufacturers list when needed
  const refreshManufacturers = async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("manufacturers")
      .select(`
        id, name, is_active, logo_url, contact_person, phone, email, website_url, 
        address_line1, address_line2, city, postal_code, country_code, 
        language_code, currency_code, tax_id, registration_number, 
        support_email, support_phone, timezone, notes, created_at, updated_at
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

  const handleFormClose = () => {
    setIsFormModalOpen(false);
    setEditingManufacturer(null);
    refreshManufacturers();
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="mx-auto max-w-7xl py-6 px-4">
        <ManufacturerCardView
          manufacturers={manufacturers}
          onAdd={handleAdd}
          onEdit={handleEdit}
          onView={handleView}
        />

        {/* Add/Edit Modal */}
        <ManufacturerFormModal
          open={isFormModalOpen}
          onOpenChange={(open) => {
            setIsFormModalOpen(open);
          }}
          manufacturer={editingManufacturer || undefined}
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
              />
            )}
          </DialogContent>
        </Dialog>
      </div>
    </div>
  );
}
