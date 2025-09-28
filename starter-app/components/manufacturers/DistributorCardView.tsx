"use client";

import { useState, useRef } from "react";
import { Search, Plus, Edit2, Eye, Building2, ShoppingBag, MapPin, Mail, Phone, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/ui/empty-state";
import { createClient } from "@/lib/supabase/client";
import { toast } from "sonner";

interface Distributor {
  id: string;
  name: string;
  is_active?: boolean;
  contact_person?: string;
  phone?: string;
  email?: string;
  logo_url?: string;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  state_region?: string;
  postal_code?: string;
  country_code?: string;
  shops_count?: number;
  orders_count?: number;
  created_at: string;
  updated_at?: string;
  category?: { id: string; name: string } | null;
}

interface Category {
  id: string;
  name: string;
}

interface DistributorCardViewProps {
  distributors: Distributor[];
  categories: Category[];
  onEdit: (distributor: Distributor) => void;
  onView: (distributor: Distributor) => void;
  onAdd: () => void;
  onLogoUpdate?: () => void;
  onDelete?: (distributor: Distributor) => void;
}

export default function DistributorCardView({ 
  distributors, 
  categories,
  onEdit, 
  onView, 
  onAdd,
  onLogoUpdate,
  onDelete
}: DistributorCardViewProps) {
  const [searchQuery, setSearchQuery] = useState("");
  const [categoryFilter, setCategoryFilter] = useState<string>("");
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [uploadingId, setUploadingId] = useState<string | null>(null);

  const handleLogoClick = (manufacturerId: string) => {
    setUploadingId(manufacturerId);
    fileInputRef.current?.click();
  };

  const handleFileChange = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file || !uploadingId) return;

    // Validate
    if (file.size > 2 * 1024 * 1024) {
      toast.error("File size must be less than 2MB");
      return;
    }
    if (!file.type.startsWith('image/') || !['image/jpeg', 'image/jpg', 'image/png', 'image/webp'].includes(file.type)) {
      toast.error("Please upload a valid image file (JPG, PNG, or WebP)");
      return;
    }

    try {
      const supabase = createClient();
      const ext = file.name.split('.').pop()?.toLowerCase() || 'png';
      const path = `distributors/${uploadingId}/logo.${ext}`;

      const { error: uploadError } = await supabase.storage
        .from("product-images")
        .upload(path, file, { upsert: true, cacheControl: "3600" });

      if (uploadError) {
        toast.error("Failed to upload logo");
        return;
      }

      const { data: urlData } = supabase.storage.from("product-images").getPublicUrl(path);

      const { error: updateError } = await supabase
        .from("distributors")
        .update({ logo_url: urlData.publicUrl })
        .eq("id", uploadingId);

      if (updateError) {
        toast.error("Failed to update distributor");
        return;
      }

      toast.success("Logo updated successfully");
      onLogoUpdate?.();
    } catch {
      toast.error("Upload failed");
    } finally {
      setUploadingId(null);
      if (fileInputRef.current) fileInputRef.current.value = "";
    }
  };

  const filteredDistributors = distributors.filter(distributor => {
    const matchesSearch = distributor.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      distributor.email?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      distributor.contact_person?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      distributor.country_code?.toLowerCase().includes(searchQuery.toLowerCase());
    
    const matchesCategory = !categoryFilter || distributor.category?.id === categoryFilter;
    
    return matchesSearch && matchesCategory;
  });

  const formatAddress = (distributor: Distributor) => {
    const parts = [
      distributor.address_line1,
      distributor.city,
      distributor.postal_code,
      distributor.country_code
    ].filter(Boolean);
    return parts.join(", ") || "No address provided";
  };

  const formatRegion = (distributor: Distributor) => {
    if (distributor.city && distributor.state_region) {
      return `${distributor.city}, ${distributor.state_region}`;
    } else if (distributor.state_region) {
      return distributor.state_region;
    } else if (distributor.city) {
      return distributor.city;
    } else {
      return "Unknown Region";
    }
  };

  return (
    <div className="space-y-6">
      {/* Hidden file input */}
      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        onChange={handleFileChange}
        className="hidden"
      />

      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Distributors Management</h1>
          <p className="text-gray-600">Manage distributor information and details</p>
        </div>
        <Button 
          onClick={() => {
            console.log("Add Distributor button clicked");
            onAdd();
          }}
          variant="primary"
          data-testid="cta-create-distributor"
        >
          <Plus className="h-4 w-4 mr-2" />
          Add Distributor
        </Button>
      </div>

      {/* Search */}
      <div className="flex gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
          <Input
            placeholder="Search distributors by name or region..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10 bg-gray-50"
          />
        </div>
        <select
          value={categoryFilter}
          onChange={(e) => setCategoryFilter(e.target.value)}
          className="px-3 py-2 border border-gray-300 rounded-md bg-white text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="">All categories</option>
          {categories.map((category) => (
            <option key={category.id} value={category.id}>
              {category.name}
            </option>
          ))}
        </select>
        <Button variant="outline" className="px-6">
          Search
        </Button>
      </div>

      {/* Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {filteredDistributors.map((distributor) => (
          <div
            key={distributor.id}
            className="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow"
          >
            {/* Header with Logo and Actions */}
            <div className="flex items-start justify-between mb-4">
              <div className="flex items-center gap-3">
                <button
                  onClick={() => handleLogoClick(distributor.id)}
                  className="relative group cursor-pointer rounded-full"
                  aria-label="Change logo"
                  disabled={uploadingId === distributor.id}
                >
                  <Building2 className="h-8 w-8 text-gray-600" />
                  {distributor.logo_url && (
                    <Avatar className="h-8 w-8 absolute inset-0">
                      <AvatarImage 
                        src={`${distributor.logo_url}?v=${distributor.updated_at ?? ""}`} 
                        alt={distributor.name} 
                      />
                      <AvatarFallback>
                        <Building2 className="h-4 w-4" />
                      </AvatarFallback>
                    </Avatar>
                  )}
                  {/* Hover overlay */}
                  <div className="absolute inset-0 bg-black bg-opacity-50 opacity-0 group-hover:opacity-100 flex items-center justify-center rounded-full transition-opacity">
                    <span className="text-white text-xs">Change logo</span>
                  </div>
                </button>
                <div>
                  <h3 className="font-semibold text-lg text-gray-900">{distributor.name}</h3>
                  <div className="flex items-center gap-2 mt-1">
                    <p className="text-gray-600 text-sm">{formatRegion(distributor)}</p>
                    {distributor.category && (
                      <Badge variant="secondary" className="text-xs">
                        {distributor.category.name}
                      </Badge>
                    )}
                  </div>
                </div>
              </div>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => onEdit(distributor)}
                  className="p-2"
                  title="Edit"
                  aria-label="Edit distributor"
                >
                  <Edit2 className="h-4 w-4" />
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => onView(distributor)}
                  className="p-2"
                  title="View"
                  aria-label="View distributor"
                >
                  <Eye className="h-4 w-4" />
                </Button>
                {onDelete && (
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => onDelete(distributor)}
                    className="p-2"
                    title="Delete"
                    aria-label="Delete distributor"
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                )}
              </div>
            </div>

            {/* Contact Information */}
            <div className="space-y-3 mb-4">
              {distributor.contact_person && (
                <div className="flex items-center gap-2 text-gray-600 text-sm">
                  <span className="font-medium">Contact:</span>
                  <span>{distributor.contact_person}</span>
                </div>
              )}
              
              {distributor.email && (
                <div className="flex items-center gap-2 text-gray-600 text-sm">
                  <Mail className="h-4 w-4" />
                  <span className="truncate">{distributor.email}</span>
                </div>
              )}
              
              {distributor.phone && (
                <div className="flex items-center gap-2 text-gray-600 text-sm">
                  <Phone className="h-4 w-4" />
                  <span>{distributor.phone}</span>
                </div>
              )}
              
              <div className="flex items-start gap-2 text-gray-600 text-sm">
                <MapPin className="h-4 w-4 mt-0.5 flex-shrink-0" />
                <span className="line-clamp-2">{formatAddress(distributor)}</span>
              </div>
            </div>

            {/* Footer Stats */}
            <div className="flex items-center justify-between pt-4 border-t border-gray-100">
              <div className="flex gap-6">
                <div className="flex items-center gap-2">
                  <ShoppingBag className="h-4 w-4 text-gray-500" />
                  <div className="text-center">
                    <div className="font-semibold text-lg">{distributor.orders_count || 0}</div>
                    <div className="text-xs text-gray-500">Orders</div>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <Building2 className="h-4 w-4 text-gray-500" />
                  <div className="text-center">
                    <div className="font-semibold text-lg">{distributor.shops_count || 0}</div>
                    <div className="text-xs text-gray-500">Shops</div>
                  </div>
                </div>
              </div>
              <Badge variant={distributor.is_active ? "default" : "secondary"}>
                {distributor.is_active ? "Active" : "Inactive"}
              </Badge>
            </div>
          </div>
        ))}
      </div>

      {/* Empty State */}
      {filteredDistributors.length === 0 && (
        <EmptyState
          icon={Building2}
          title="No distributors found"
          body={searchQuery ? "Try adjusting your search terms" : "Get started by adding your first distributor"}
          primaryCta={!searchQuery ? {
            label: "Add Distributor",
            onClick: onAdd
          } : undefined}
        />
      )}
    </div>
  );
}