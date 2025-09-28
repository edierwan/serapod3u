"use client";

import React, { useState } from "react";
import Image from "next/image";
import { Edit, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import DistributorFormModal from "@/components/distributors/DistributorFormModal";
import { Distributor, Category } from "@/lib/types/master";

interface DetailsTabProps {
  distributor: Distributor | null;
  canEdit: boolean;
  onRefresh?: () => void;
  categories: Category[];
}

export default function DetailsTab({ distributor, canEdit, onRefresh, categories }: DetailsTabProps) {
  const [isCreateOpen, setIsCreateOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);

  if (!distributor) {
    return (
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <h2 className="text-lg font-semibold">Distributor Details</h2>
          <Button
            onClick={() => setIsCreateOpen(true)}
            variant="outline"
            className="border-blue-200 text-blue-700 hover:bg-blue-50 hover:border-blue-300 px-4 py-2 h-9 font-medium"
          >
            <Plus className="h-4 w-4 mr-2" />
            Add Distributor
          </Button>
        </div>

        <div className="flex items-center justify-center h-64">
          <div className="text-center">
            <p className="text-muted-foreground">Select a distributor from the list to view details</p>
          </div>
        </div>

        {/* Create Modal */}
        <DistributorFormModal
          open={isCreateOpen}
          onOpenChange={setIsCreateOpen}
          distributor={undefined}
          categories={categories}
        />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-lg font-semibold">Distributor Details</h2>
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
        {distributor.logo_url && (
          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-2">Logo</label>
            <div className="relative h-16 w-32 border border-border rounded overflow-hidden">
              <Image
                src={distributor.logo_url}
                alt={`${distributor.name} logo`}
                fill
                className="object-contain"
                sizes="128px"
                onError={(e) => {
                  (e.target as HTMLImageElement).style.display = "none";
                }}
              />
            </div>
          </div>
        )}

        {/* Basic Information */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Name</label>
            <p className="text-base font-medium">{distributor.name}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Status</label>
            <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
              distributor.is_active ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"
            }`}>
              {distributor.is_active ? "Active" : "Inactive"}
            </span>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Contact Person</label>
            <p className="text-base">{distributor.contact_person || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Phone</label>
            <p className="text-base">{distributor.phone || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Email</label>
            <p className="text-base">{distributor.email || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Website</label>
            <p className="text-base">
              {distributor.website_url ? (
                <a href={distributor.website_url} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">
                  {distributor.website_url}
                </a>
              ) : "Not provided"}
            </p>
          </div>
        </div>

        {/* Address */}
        {(distributor.address_line1 || distributor.city || distributor.country_code) && (
          <div className="border-t border-border pt-6">
            <h3 className="text-sm font-semibold mb-4">Address</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="md:col-span-2">
                <label className="block text-sm font-medium text-muted-foreground mb-1">Address Line 1</label>
                <p className="text-base">{distributor.address_line1 || "Not provided"}</p>
              </div>

              {distributor.address_line2 && (
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-muted-foreground mb-1">Address Line 2</label>
                  <p className="text-base">{distributor.address_line2}</p>
                </div>
              )}

              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">City</label>
                <p className="text-base">{distributor.city || "Not provided"}</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">Postal Code</label>
                <p className="text-base">{distributor.postal_code || "Not provided"}</p>
              </div>

              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">Country</label>
                <p className="text-base">{distributor.country_code || "Not provided"}</p>
              </div>
            </div>
          </div>
        )}

        {/* Business Information */}
        <div className="border-t border-border pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Website</label>
              <p className="text-base">{distributor.website_url ? <a href={distributor.website_url} target="_blank" rel="noopener noreferrer" className="text-blue-600 hover:underline">{distributor.website_url}</a> : "Not provided"}</p>
            </div>

            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">WhatsApp</label>
              <p className="text-base">{distributor.whatsapp || "Not provided"}</p>
            </div>
          </div>
        </div>

        {/* Notes */}
        {distributor.notes && (
          <div className="border-t border-border pt-6">
            <label className="block text-sm font-medium text-muted-foreground mb-1">Notes</label>
            <p className="text-base whitespace-pre-wrap">{distributor.notes}</p>
          </div>
        )}

        {/* Timestamps */}
        <div className="border-t border-border pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-muted-foreground mb-1">Created</label>
              <p className="text-base">{distributor.created_at ? new Date(distributor.created_at).toLocaleString() : "Unknown"}</p>
            </div>

            {distributor.updated_at && (
              <div>
                <label className="block text-sm font-medium text-muted-foreground mb-1">Last Updated</label>
                <p className="text-base">{new Date(distributor.updated_at).toLocaleString()}</p>
              </div>
            )}
          </div>
        </div>
      </div>

        <DistributorFormModal
          open={isCreateOpen}
          onOpenChange={setIsCreateOpen}
          distributor={undefined}
          onSuccess={onRefresh}
          categories={categories}
        />

        {/* Edit Modal */}
        <DistributorFormModal
          open={isEditOpen}
          onOpenChange={setIsEditOpen}
          distributor={distributor}
          onSuccess={onRefresh}
          categories={categories}
        />
    </div>
  );
}
