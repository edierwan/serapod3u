"use client";

import { useState, useTransition } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { upsertManufacturer } from "@/app/(protected)/master/manufacturers/actions";
import { toast } from "sonner";

interface Manufacturer {
  id?: string;
  name: string;
  is_active?: boolean;
  contact_person?: string;
  phone?: string;
  email?: string;
  address?: string;
  legal_name?: string;
  brand_name?: string;
  registration_number?: string;
  tax_id?: string;
  country_code?: string;
  timezone?: string;
  language_code?: string;
  currency_code?: string;
  website_url?: string;
  support_email?: string;
  support_phone?: string;
  whatsapp?: string;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  state_region?: string;
  postal_code?: string;
  secondary_email?: string;
  fax?: string;
  social_links?: string;
  certifications?: string;
  notes?: string;
  logo_url?: string;
  updated_at?: string;
}

interface ManufacturerFormModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  manufacturer?: Manufacturer | null;
  onSuccess?: () => void;
}

export default function ManufacturerFormModal({
  open,
  onOpenChange,
  manufacturer,
  onSuccess,
}: ManufacturerFormModalProps) {
  const [isPending, startTransition] = useTransition();
  const [logoPreview, setLogoPreview] = useState<string | null>(null);
  const [logoFile, setLogoFile] = useState<File | null>(null);

  const handleLogoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setLogoFile(file);
      const reader = new FileReader();
      reader.onload = (e) => {
        setLogoPreview(e.target?.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);

    // Add logo file if selected
    if (logoFile) {
      formData.set("logo", logoFile);
    }

    startTransition(async () => {
      const result = await upsertManufacturer(null, formData);
      if (result.success) {
        toast.success(manufacturer ? "Manufacturer updated successfully" : "Manufacturer created successfully");
        onOpenChange(false);
        setLogoPreview(null);
        setLogoFile(null);
        onSuccess?.();
      } else {
        toast.error(result.message || "Failed to save manufacturer");
      }
    });
  };

  const handleClose = () => {
    onOpenChange(false);
    setLogoPreview(null);
    setLogoFile(null);
  };

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>
            {manufacturer ? "Edit Manufacturer" : "Add New Manufacturer"}
          </DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Hidden ID field */}
          {manufacturer?.id && (
            <input type="hidden" name="id" value={manufacturer.id} />
          )}

          {/* Logo Upload Section */}
          <div className="flex items-center gap-4 p-4 border rounded-lg">
            <Avatar className="h-16 w-16">
              {logoPreview || manufacturer?.logo_url ? (
                <AvatarImage
                  src={logoPreview || `${manufacturer?.logo_url}?v=${manufacturer?.updated_at ?? ""}`}
                  alt="Logo preview"
                />
              ) : (
                <AvatarFallback className="text-lg">
                  {manufacturer?.name?.slice(0, 2).toUpperCase() || "MN"}
                </AvatarFallback>
              )}
            </Avatar>
            <div className="flex-1">
              <label htmlFor="logo" className="block text-sm font-medium mb-2">
                Logo
              </label>
              <Input
                id="logo"
                type="file"
                accept="image/*"
                onChange={handleLogoChange}
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
              <label htmlFor="name">Name *</label>
              <Input
                id="name"
                name="name"
                defaultValue={manufacturer?.name || ""}
                required
                placeholder="Manufacturer name"
              />
            </div>
            <div>
              <label htmlFor="legal_name">Legal Name</label>
              <Input
                id="legal_name"
                name="legal_name"
                defaultValue={manufacturer?.legal_name || ""}
                placeholder="Registered legal name"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label htmlFor="brand_name">Brand Name</label>
              <Input
                id="brand_name"
                name="brand_name"
                defaultValue={manufacturer?.brand_name || ""}
                placeholder="Marketing/brand display name"
              />
            </div>
            <div>
              <label htmlFor="registration_number">Registration Number</label>
              <Input
                id="registration_number"
                name="registration_number"
                defaultValue={manufacturer?.registration_number || ""}
                placeholder="Company/business registration number"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label htmlFor="tax_id">Tax ID</label>
              <Input
                id="tax_id"
                name="tax_id"
                defaultValue={manufacturer?.tax_id || ""}
                placeholder="Tax/VAT/GST identifier"
              />
            </div>
            <div>
              <label htmlFor="is_active">Status</label>
              <Select name="is_active" defaultValue={manufacturer?.is_active !== false ? "true" : "false"}>
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
                <label htmlFor="contact_person">Contact Person</label>
                <Input
                  id="contact_person"
                  name="contact_person"
                  defaultValue={manufacturer?.contact_person || ""}
                  placeholder="Primary contact person"
                />
              </div>
              <div>
                <label htmlFor="phone">Phone</label>
                <Input
                  id="phone"
                  name="phone"
                  defaultValue={manufacturer?.phone || ""}
                  placeholder="Primary phone number"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label htmlFor="email">Email</label>
                <Input
                  id="email"
                  name="email"
                  type="email"
                  defaultValue={manufacturer?.email || ""}
                  placeholder="Primary email address"
                />
              </div>
              <div>
                <label htmlFor="secondary_email">Secondary Email</label>
                <Input
                  id="secondary_email"
                  name="secondary_email"
                  type="email"
                  defaultValue={manufacturer?.secondary_email || ""}
                  placeholder="Secondary email address"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label htmlFor="support_email">Support Email</label>
                <Input
                  id="support_email"
                  name="support_email"
                  type="email"
                  defaultValue={manufacturer?.support_email || ""}
                  placeholder="Support contact email"
                />
              </div>
              <div>
                <label htmlFor="support_phone">Support Phone</label>
                <Input
                  id="support_phone"
                  name="support_phone"
                  defaultValue={manufacturer?.support_phone || ""}
                  placeholder="Support phone"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label htmlFor="whatsapp">WhatsApp</label>
                <Input
                  id="whatsapp"
                  name="whatsapp"
                  defaultValue={manufacturer?.whatsapp || ""}
                  placeholder="WhatsApp contact"
                />
              </div>
              <div>
                <label htmlFor="fax">Fax</label>
                <Input
                  id="fax"
                  name="fax"
                  defaultValue={manufacturer?.fax || ""}
                  placeholder="Fax number"
                />
              </div>
            </div>
          </div>

          {/* Address Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium">Address Information</h3>

            <div>
              <label htmlFor="address_line1">Address Line 1</label>
              <Input
                id="address_line1"
                name="address_line1"
                defaultValue={manufacturer?.address_line1 || ""}
                placeholder="Street address"
              />
            </div>

            <div>
              <label htmlFor="address_line2">Address Line 2</label>
              <Input
                id="address_line2"
                name="address_line2"
                defaultValue={manufacturer?.address_line2 || ""}
                placeholder="Additional address information"
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label htmlFor="city">City</label>
                <Input
                  id="city"
                  name="city"
                  defaultValue={manufacturer?.city || ""}
                  placeholder="City"
                />
              </div>
              <div>
                <label htmlFor="state_region">State/Region</label>
                <Input
                  id="state_region"
                  name="state_region"
                  defaultValue={manufacturer?.state_region || ""}
                  placeholder="State or region"
                />
              </div>
              <div>
                <label htmlFor="postal_code">Postal Code</label>
                <Input
                  id="postal_code"
                  name="postal_code"
                  defaultValue={manufacturer?.postal_code || ""}
                  placeholder="Postal code"
                />
              </div>
            </div>

            <div>
              <label htmlFor="address">Full Address (Legacy)</label>
              <Textarea
                id="address"
                name="address"
                defaultValue={manufacturer?.address || ""}
                placeholder="Full address (if different from above)"
                rows={3}
              />
            </div>
          </div>

          {/* Business Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium">Business Information</h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label htmlFor="country_code">Country Code</label>
                <Input
                  id="country_code"
                  name="country_code"
                  defaultValue={manufacturer?.country_code || ""}
                  placeholder="ISO-3166-1 alpha-2 (e.g., MY, SG)"
                  maxLength={2}
                />
              </div>
              <div>
                <label htmlFor="language_code">Language Code</label>
                <Input
                  id="language_code"
                  name="language_code"
                  defaultValue={manufacturer?.language_code || ""}
                  placeholder="ISO-639-1 (e.g., en, ms)"
                  maxLength={2}
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label htmlFor="currency_code">Currency Code</label>
                <Input
                  id="currency_code"
                  name="currency_code"
                  defaultValue={manufacturer?.currency_code || ""}
                  placeholder="ISO-4217 (e.g., MYR, SGD)"
                  maxLength={3}
                />
              </div>
              <div>
                <label htmlFor="timezone">Timezone</label>
                <Input
                  id="timezone"
                  name="timezone"
                  defaultValue={manufacturer?.timezone || ""}
                  placeholder="Timezone (e.g., Asia/Kuala_Lumpur)"
                />
              </div>
            </div>

            <div>
              <label htmlFor="website_url">Website URL</label>
              <Input
                id="website_url"
                name="website_url"
                type="url"
                defaultValue={manufacturer?.website_url || ""}
                placeholder="https://example.com"
              />
            </div>
          </div>

          {/* Additional Information */}
          <div className="space-y-4">
            <h3 className="text-lg font-medium">Additional Information</h3>

            <div>
              <label htmlFor="social_links">Social Links (JSON)</label>
              <Textarea
                id="social_links"
                name="social_links"
                defaultValue={manufacturer?.social_links || ""}
                placeholder='{"facebook": "url", "twitter": "url"}'
                rows={3}
              />
            </div>

            <div>
              <label htmlFor="certifications">Certifications (JSON)</label>
              <Textarea
                id="certifications"
                name="certifications"
                defaultValue={manufacturer?.certifications || ""}
                placeholder='[{"name": "ISO 9001", "issued_date": "2023-01-01"}]'
                rows={3}
              />
            </div>

            <div>
              <label htmlFor="notes">Notes</label>
              <Textarea
                id="notes"
                name="notes"
                defaultValue={manufacturer?.notes || ""}
                placeholder="Additional notes about the manufacturer"
                rows={3}
              />
            </div>
          </div>

          <div className="flex justify-end gap-2 pt-4">
            <Button type="button" variant="outline" onClick={handleClose} disabled={isPending}>
              Cancel
            </Button>
            <Button type="submit" variant="outline" disabled={isPending}>
              {isPending ? "Saving..." : manufacturer ? "Update Manufacturer" : "Create Manufacturer"}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}