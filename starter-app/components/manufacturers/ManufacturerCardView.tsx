"use client";

import { useState } from "react";
import { Search, Plus, Edit2, Eye, Building2, ShoppingBag, MapPin, Mail, Phone } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/ui/empty-state";

interface Manufacturer {
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
  postal_code?: string;
  country_code?: string;
  products_count?: number;
  orders_count?: number;
  created_at: string;
  updated_at?: string;
}

interface ManufacturerCardViewProps {
  manufacturers: Manufacturer[];
  onEdit: (manufacturer: Manufacturer) => void;
  onView: (manufacturer: Manufacturer) => void;
  onAdd: () => void;
}

export default function ManufacturerCardView({ 
  manufacturers, 
  onEdit, 
  onView, 
  onAdd 
}: ManufacturerCardViewProps) {
  const [searchQuery, setSearchQuery] = useState("");

  const filteredManufacturers = manufacturers.filter(manufacturer =>
    manufacturer.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    manufacturer.email?.toLowerCase().includes(searchQuery.toLowerCase()) ||
    manufacturer.contact_person?.toLowerCase().includes(searchQuery.toLowerCase()) ||
    manufacturer.country_code?.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const formatAddress = (manufacturer: Manufacturer) => {
    const parts = [
      manufacturer.address_line1,
      manufacturer.city,
      manufacturer.postal_code,
      manufacturer.country_code
    ].filter(Boolean);
    return parts.join(", ") || "No address provided";
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Manufacturers Management</h1>
          <p className="text-gray-600">Manage manufacturer information and details</p>
        </div>
        <Button 
          onClick={() => {
            console.log("Add Manufacturer button clicked");
            onAdd();
          }}
          variant="primary"
        >
          <Plus className="h-4 w-4 mr-2" />
          Add Manufacturer
        </Button>
      </div>

      {/* Search */}
      <div className="flex gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
          <Input
            placeholder="Search manufacturers by name or region..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10 bg-gray-50"
          />
        </div>
        <Button variant="outline" className="px-6">
          Search
        </Button>
      </div>

      {/* Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {filteredManufacturers.map((manufacturer) => (
          <div
            key={manufacturer.id}
            className="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow"
          >
            {/* Header with Logo and Actions */}
            <div className="flex items-start justify-between mb-4">
              <div className="flex items-center gap-3">
                <div className="relative">
                  <Building2 className="h-8 w-8 text-gray-600" />
                  {manufacturer.logo_url && (
                    <Avatar className="h-8 w-8 absolute inset-0">
                      <AvatarImage 
                        src={`${manufacturer.logo_url}?v=${manufacturer.updated_at ?? ""}`} 
                        alt={manufacturer.name} 
                      />
                      <AvatarFallback>
                        <Building2 className="h-4 w-4" />
                      </AvatarFallback>
                    </Avatar>
                  )}
                </div>
                <div>
                  <h3 className="font-semibold text-lg text-gray-900">{manufacturer.name}</h3>
                  <p className="text-gray-600 text-sm">{manufacturer.country_code || "Unknown Region"}</p>
                </div>
              </div>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => onEdit(manufacturer)}
                  className="p-2"
                >
                  <Edit2 className="h-4 w-4" />
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => onView(manufacturer)}
                  className="p-2"
                >
                  <Eye className="h-4 w-4" />
                </Button>
              </div>
            </div>

            {/* Contact Information */}
            <div className="space-y-3 mb-4">
              {manufacturer.contact_person && (
                <div className="flex items-center gap-2 text-gray-600 text-sm">
                  <span className="font-medium">Contact:</span>
                  <span>{manufacturer.contact_person}</span>
                </div>
              )}
              
              {manufacturer.email && (
                <div className="flex items-center gap-2 text-gray-600 text-sm">
                  <Mail className="h-4 w-4" />
                  <span className="truncate">{manufacturer.email}</span>
                </div>
              )}
              
              {manufacturer.phone && (
                <div className="flex items-center gap-2 text-gray-600 text-sm">
                  <Phone className="h-4 w-4" />
                  <span>{manufacturer.phone}</span>
                </div>
              )}
              
              <div className="flex items-start gap-2 text-gray-600 text-sm">
                <MapPin className="h-4 w-4 mt-0.5 flex-shrink-0" />
                <span className="line-clamp-2">{formatAddress(manufacturer)}</span>
              </div>
            </div>

            {/* Footer Stats */}
            <div className="flex items-center justify-between pt-4 border-t border-gray-100">
              <div className="flex gap-6">
                <div className="flex items-center gap-2">
                  <ShoppingBag className="h-4 w-4 text-gray-500" />
                  <div className="text-center">
                    <div className="font-semibold text-lg">{manufacturer.orders_count || 0}</div>
                    <div className="text-xs text-gray-500">Orders</div>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <Building2 className="h-4 w-4 text-gray-500" />
                  <div className="text-center">
                    <div className="font-semibold text-lg">{manufacturer.products_count || 0}</div>
                    <div className="text-xs text-gray-500">Products</div>
                  </div>
                </div>
              </div>
              <Badge variant={manufacturer.is_active ? "default" : "secondary"}>
                {manufacturer.is_active ? "Active" : "Inactive"}
              </Badge>
            </div>
          </div>
        ))}
      </div>

      {/* Empty State */}
      {filteredManufacturers.length === 0 && (
        <EmptyState
          icon={Building2}
          title="No manufacturers found"
          body={searchQuery ? "Try adjusting your search terms" : "Get started by adding your first manufacturer"}
          primaryCta={!searchQuery ? {
            label: "Add Manufacturer",
            onClick: onAdd
          } : undefined}
        />
      )}
    </div>
  );
}