"use client";

import { useState } from "react";
import Image from "next/image";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { upsertManufacturer } from "@/app/(protected)/master/manufacturers/actions";

type Manufacturer = {
  id?: string;
  name?: string;
  is_active?: boolean;
  contact_person?: string;
  phone?: string;
  email?: string;
  whatsapp?: string;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  state_region?: string;
  postal_code?: string;
  address?: string;
  website_url?: string;
  notes?: string;
  logo_url?: string | null;
};

interface ManufacturerFormModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  manufacturer?: Manufacturer;
  onSuccess?: () => void;
}

export default function ManufacturerFormModal({
  open,
  onOpenChange,
  manufacturer,
  onSuccess
}: ManufacturerFormModalProps) {
  const initialUrl = manufacturer?.logo_url ?? null;
  const [preview, setPreview] = useState<string | null>(initialUrl);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>
            {manufacturer?.id ? "Edit Manufacturer" : "Add New Manufacturer"}
          </DialogTitle>
        </DialogHeader>

        <form
          action={async (fd) => {
            const res = await upsertManufacturer(null, fd);
            if (res?.success) {
              // force refresh of image everywhere
              if (res.logo_url) setPreview(`${res.logo_url}?v=${Date.now()}`);
              onOpenChange(false);
              onSuccess?.();
            } else {
              console.error(res);
              alert(res?.message ?? "Save failed");
            }
          }}
          className="space-y-6"
        >
          {/* keep id on edit */}
          {manufacturer?.id && <input type="hidden" name="id" defaultValue={manufacturer.id} />}

          {/* Logo Upload Section */}
          <div className="flex items-center gap-4 p-4 border rounded-lg">
            <div className="relative h-16 w-16 overflow-hidden rounded-full border">
              {preview ? (
                <Image src={preview} alt="Logo" fill sizes="64px" className="object-cover" />
              ) : (
                <div className="h-full w-full bg-gray-200 flex items-center justify-center text-gray-500 text-sm">
                  Logo
                </div>
              )}
            </div>
            <div className="flex-1">
              <label className="block text-sm font-medium mb-2">Logo</label>
              <Input
                type="file"
                name="logo"
                accept="image/*"
                onChange={(e) => {
                  const f = e.target.files?.[0];
                  if (f) setPreview(URL.createObjectURL(f));
                }}
                className="w-full"
              />
              <p className="text-xs text-muted-foreground mt-1">
                Upload a logo image (max 2MB)
              </p>
            </div>
          </div>

          {/* Basic Information */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Name *</label>
              <Input
                name="name"
                defaultValue={manufacturer?.name ?? ""}
                required
                placeholder="Manufacturer name"
              />
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Status</label>
              <Select name="is_active" defaultValue={String(manufacturer?.is_active ?? true)}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="true">Active</SelectItem>
                  <SelectItem value="false">Inactive</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Contact Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium">Contact Information</h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Contact Person</label>
                <Input
                  name="contact_person"
                  defaultValue={manufacturer?.contact_person ?? ""}
                  placeholder="Primary contact person"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Phone</label>
                <Input
                  name="phone"
                  defaultValue={manufacturer?.phone ?? ""}
                  placeholder="Primary phone number"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">Email</label>
                <Input
                  name="email"
                  type="email"
                  defaultValue={manufacturer?.email ?? ""}
                  placeholder="Primary email address"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">WhatsApp</label>
                <Input
                  name="whatsapp"
                  defaultValue={manufacturer?.whatsapp ?? ""}
                  placeholder="WhatsApp contact"
                />
              </div>
            </div>
          </div>

          {/* Address Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium">Address Information</h3>

            <div>
              <label className="block text-sm font-medium mb-1">Address Line 1</label>
              <Input
                name="address_line1"
                defaultValue={manufacturer?.address_line1 ?? ""}
                placeholder="Street address"
              />
            </div>

            <div>
              <label className="block text-sm font-medium mb-1">Address Line 2</label>
              <Input
                name="address_line2"
                defaultValue={manufacturer?.address_line2 ?? ""}
                placeholder="Additional address information"
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">City</label>
                <Input
                  name="city"
                  defaultValue={manufacturer?.city ?? ""}
                  placeholder="City"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">State/Region</label>
                <Input
                  name="state_region"
                  defaultValue={manufacturer?.state_region ?? ""}
                  placeholder="State or region"
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Postal Code</label>
                <Input
                  name="postal_code"
                  defaultValue={manufacturer?.postal_code ?? ""}
                  placeholder="Postal code"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium mb-1">Full Address (Legacy)</label>
              <Textarea
                name="address"
                defaultValue={manufacturer?.address ?? ""}
                placeholder="Full address (if different from above)"
                rows={3}
              />
            </div>
          </div>

          {/* Business Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium">Business Information</h3>

            <div>
              <label className="block text-sm font-medium mb-1">Website URL</label>
              <Input
                name="website_url"
                type="url"
                defaultValue={manufacturer?.website_url ?? ""}
                placeholder="https://example.com"
              />
            </div>
          </div>

          {/* Additional Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium">Additional Information</h3>

            <div>
              <label className="block text-sm font-medium mb-1">Notes</label>
              <Textarea
                name="notes"
                defaultValue={manufacturer?.notes ?? ""}
                placeholder="Additional notes about the manufacturer"
                rows={3}
              />
            </div>
          </div>

          <div className="flex justify-end gap-2 pt-4">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="submit">
              {manufacturer?.id ? "Update Manufacturer" : "Create Manufacturer"}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}