"use client";

import React, { useState } from "react";
import { Edit, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import ManufacturerFormModal from "@/components/products/ManufacturerFormModal";

interface Manufacturer {
  id: string;
  name: string;
  is_active?: boolean;
  contact_person?: string;
  phone?: string;
  email?: string;
  website_url?: string;
  logo_url?: string;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  postal_code?: string;
  country_code?: string;
  language_code?: string;
  currency_code?: string;
  tax_id?: string;
  registration_number?: string;
  support_email?: string;
  support_phone?: string;
  timezone?: string;
  notes?: string;
  created_at: string;
  updated_at?: string;
}

interface DetailsTabProps {
  manufacturer: Manufacturer | null;
  canEdit: boolean;
  onRefresh?: () => void;
}

export default function DetailsTab({ manufacturer, canEdit, onRefresh }: DetailsTabProps) {
  const [isCreateOpen, setIsCreateOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);

  if (!manufacturer) {
    return (
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <h2 className="text-lg font-semibold">Manufacturer Details</h2>
          <Button
            onClick={() => setIsCreateOpen(true)}
            variant="outline"
            className="border-blue-200 text-blue-700 hover:bg-blue-50 hover:border-blue-300 px-4 py-2 h-9 font-medium"
          >
            <Plus className="h-4 w-4 mr-2" />
            Add Manufacturer
          </Button>
        </div>

        <div className="flex items-center justify-center h-64">
          <div className="text-center">
            <p className="text-muted-foreground">Select a manufacturer from the list to view details</p>
          </div>
        </div>

        {/* Create Modal */}
        <ManufacturerFormModal
          open={isCreateOpen}
          onOpenChange={setIsCreateOpen}
          manufacturer={null}
        />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-lg font-semibold">Manufacturer Details</h2>
        <div className="flex gap-2">
          <Button
            variant="outline"
            onClick={() => setIsCreateOpen(true)}
            className="border-blue-200 text-blue-700 hover:bg-blue-50 hover:border-blue-300 px-4 py-2 h-9 font-medium"
          >
            <Plus className="h-4 w-4 mr-2" />
            Add New
          </Button>

          {canEdit && (
            <Button onClick={() => setIsEditOpen(true)}>
              <Edit className="h-4 w-4 mr-2" />
              Edit
            </Button>
          )}
        </div>
      </div>

      <div className="bg-white border border-border rounded-lg p-6 space-y-6">
        {/* Logo */}
        {manufacturer.logo_url && (
          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-2">Logo</label>
            <img
              src={manufacturer.logo_url}
              alt={manufacturer.name}
              className="h-16 w-auto object-contain border border-border rounded"
              onError={(e) => {
                (e.target as HTMLImageElement).style.display = "none";
              }}
            />
          </div>
        )}

        {/* Basic Information */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Name</label>
            <p className="text-base font-medium">{manufacturer.name}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Status</label>
            <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
              manufacturer.is_active ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"
            }`}>
              {manufacturer.is_active ? "Active" : "Inactive"}
            </span>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Contact Person</label>
            <p className="text-base">{manufacturer.contact_person || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Phone</label>
            <p className="text-base">{manufacturer.phone || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Email</label>
            <p className="text-base">{manufacturer.email || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Website</label>
            <p className="text-base">
              {manufacturer.website_url ? (
                <a href={manufacturer.website_url} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                  {manufacturer.website_url}
                </a>
              ) : "Not provided"}
            </p>
          </div>
        </div>

        {/* Address */}
        {(manufacturer.address_line1 || manufacturer.city || manufacturer.country_code) && (
          <div className="border-t border-border pt-6">
            <h3 className="text-sm font-semibold mb-4">Address</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="md:col-span-2">
                <label className="block text-sm font-medium text-muted-foreground mb-1">Address Line 1</label>
                <p className="text-base">{manufacturer.address_line1 || "Not provided"}</p>
              </div>

              {manufacturer.address_line2 && (
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-muted-foreground mb-1">Address Line 2</label>
                  <p className="text-base">{manufacturer.address_line2}</p>
                </div>
              )}

              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">City</label>
                <p className="text-base">{manufacturer.city || "Not provided"}</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">Postal Code</label>
                <p className="text-base">{manufacturer.postal_code || "Not provided"}</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">Country</label>
                <p className="text-base">{manufacturer.country_code || "Not provided"}</p>
              </div>
            </div>
          </div>
        )}

        {/* Locale & Compliance */}
        <div className="border-t border-border pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Language</label>
              <p className="text-base">{manufacturer.language_code || "Not provided"}</p>
            </div>

            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Currency</label>
              <p className="text-base">{manufacturer.currency_code || "Not provided"}</p>
            </div>

            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Tax ID</label>
              <p className="text-base">{manufacturer.tax_id || "Not provided"}</p>
            </div>

            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Registration No</label>
              <p className="text-base">{manufacturer.registration_number || "Not provided"}</p>
            </div>

            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Support Email</label>
              <p className="text-base">{manufacturer.support_email || "Not provided"}</p>
            </div>

            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Support Phone</label>
              <p className="text-base">{manufacturer.support_phone || "Not provided"}</p>
            </div>
          </div>
        </div>

        {/* Notes */}
        {manufacturer.notes && (
          <div className="border-t border-border pt-6">
            <label className="block text-sm font-medium text-muted-foreground mb-1">Notes</label>
            <p className="text-base whitespace-pre-wrap">{manufacturer.notes}</p>
          </div>
        )}

        {/* Timestamps */}
        <div className="border-t border-border pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Created</label>
              <p className="text-base">{new Date(manufacturer.created_at).toLocaleString()}</p>
            </div>

            {manufacturer.updated_at && (
              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">Last Updated</label>
                <p className="text-base">{new Date(manufacturer.updated_at).toLocaleString()}</p>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Create Modal */}
      <ManufacturerFormModal
        open={isCreateOpen}
        onOpenChange={setIsCreateOpen}
        manufacturer={null}
        onSuccess={onRefresh}
      />

      {/* Edit Modal */}
      <ManufacturerFormModal
        open={isEditOpen}
        onOpenChange={setIsEditOpen}
        manufacturer={manufacturer}
        onSuccess={onRefresh}
      />
    </div>
  );
}
