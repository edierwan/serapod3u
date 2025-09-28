"use client";

import { useState, useEffect, useRef } from "react";
import Image from "next/image";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { StatusToggle } from "@/components/ui/status-toggle";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { upsertManufacturer } from "@/app/(protected)/master/manufacturers/actions";
import { Upload } from "lucide-react";
import { toast } from "sonner";
import { useNameAvailability } from "@/lib/hooks/useNameAvailability";

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
  category_id?: string | null;
};

interface Category {
  id: string;
  name: string;
}

interface ManufacturerFormModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  manufacturer?: Manufacturer;
  categories: Category[];
  onSuccess?: () => void;
}

export default function ManufacturerFormModal({
  open,
  onOpenChange,
  manufacturer,
  categories,
  onSuccess
}: ManufacturerFormModalProps) {
  const [preview, setPreview] = useState<string | null>(null);
  const [formKey, setFormKey] = useState(0); // Key to reset file input
  const [selectedFileName, setSelectedFileName] = useState<string>("");
  const [fileError, setFileError] = useState<string | null>(null);
  const [isActive, setIsActive] = useState(manufacturer?.is_active ?? true);
  const [selectedCategoryId, setSelectedCategoryId] = useState<string>(manufacturer?.category_id ? manufacturer.category_id : "none");
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Name availability check hook
  const [{ available: nameAvailable, error: nameError, isChecking: isCheckingName }, checkName] = useNameAvailability({
    entity: "manufacturers",
    excludeId: manufacturer?.id,
    minLength: 2
  });

  // Reset state when modal opens/closes or manufacturer changes
  useEffect(() => {
    if (open) {
      setFileError(null);
      setSelectedFileName("");
      setPreview(manufacturer?.logo_url ?? null);
      setIsActive(manufacturer?.is_active ?? true);
      setSelectedCategoryId(manufacturer?.category_id ? manufacturer.category_id : "none");
      // Reset form for create mode
      if (!manufacturer) {
        setFormKey(prev => prev + 1); // Remount file input to clear it
      }
    }
  }, [open, manufacturer]);

  const validateFile = (file: File): string | null => {
    if (file.size > 2 * 1024 * 1024) {
      return "Image must be 2MB or smaller";
    }
    if (!['image/jpeg', 'image/jpg', 'image/png', 'image/webp'].includes(file.type)) {
      return "Unsupported file type. Please upload PNG, JPG, or WEBP";
    }
    return null;
  };

  const handleFileSelect = (file: File | null) => {
    setFileError(null);
    if (!file) {
      setSelectedFileName("");
      setPreview(manufacturer?.logo_url ?? null);
      return;
    }

    const error = validateFile(file);
    if (error) {
      setFileError(error);
      toast.error(error);
      setSelectedFileName("");
      setPreview(manufacturer?.logo_url ?? null);
      // Clear the file input
      if (fileInputRef.current) fileInputRef.current.value = "";
      return;
    }

    setSelectedFileName(file.name);
    setPreview(URL.createObjectURL(file));
  };

  const triggerFileInput = () => {
    fileInputRef.current?.click();
  };

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
          {/* Controlled status toggle value */}
          <input type="hidden" name="is_active" value={isActive ? "true" : "false"} />
          {/* Category selection */}
          <input type="hidden" name="categoryId" value={selectedCategoryId === "none" ? "" : selectedCategoryId} />

          {/* Logo Upload Section */}
          <div className="p-4 border rounded-lg">
            <div className="flex flex-col sm:flex-row items-start sm:items-center gap-4">
              {/* Avatar */}
              <button
                type="button"
                onClick={triggerFileInput}
                className="relative h-16 w-16 overflow-hidden rounded-full border cursor-pointer hover:bg-gray-50 transition-colors"
                aria-label="Select logo image"
              >
                {preview ? (
                  <Image src={preview} alt="Logo preview" fill sizes="64px" className="object-cover" />
                ) : (
                  <div className="h-full w-full bg-gray-200 flex items-center justify-center text-gray-500 text-sm">
                    Logo
                  </div>
                )}
              </button>

              {/* File Input Controls */}
              <div className="flex-1 min-w-0">
                <label className="block text-sm font-medium mb-2">Logo</label>
                <div className="flex items-center gap-2">
                  <Button
                    type="button"
                    variant="outline"
                    size="default"
                    onClick={triggerFileInput}
                    className="h-10 px-4"
                    aria-label="Select logo image"
                    aria-describedby="logo-helper"
                  >
                    <Upload className="h-4 w-4 mr-2" />
                    Select Image
                  </Button>
                  <span className={`text-sm truncate ${selectedFileName ? 'text-foreground' : 'text-muted-foreground'}`}>
                    {selectedFileName || "No file selected"}
                  </span>
                </div>
                <p
                  id="logo-helper"
                  className={`text-xs mt-1 ${fileError ? 'text-red-600' : 'text-muted-foreground'}`}
                >
                  {fileError || "Upload a logo image (max 2MB)"}
                </p>
              </div>
            </div>

            {/* Hidden File Input */}
            <input
              ref={fileInputRef}
              key={formKey}
              type="file"
              name="logo"
              accept="image/png,image/jpeg,image/jpg,image/webp"
              onChange={(e) => {
                const file = e.target.files?.[0] || null;
                handleFileSelect(file);
              }}
              className="sr-only"
              aria-hidden="true"
            />
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
                onChange={(e) => checkName(e.target.value)}
                className={nameError ? "border-red-500" : ""}
              />
              {nameError && (
                <p className="text-sm text-red-600 mt-1">{nameError}</p>
              )}
              {isCheckingName && (
                <p className="text-sm text-gray-500 mt-1">Checking availability...</p>
              )}
            </div>
            <div>
              <label className="block text-sm font-medium mb-1">Status</label>
              <StatusToggle
                name="is_active"
                checked={isActive}
                onCheckedChange={setIsActive}
              />
            </div>
          </div>

          {/* Category */}
          <div>
            <label className="block text-sm font-medium mb-1">Category</label>
            <Select value={selectedCategoryId} onValueChange={setSelectedCategoryId}>
              <SelectTrigger className="w-full">
                <SelectValue placeholder="Select a category" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="none">No category</SelectItem>
                {categories.map((category) => (
                  <SelectItem key={category.id} value={category.id}>
                    {category.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
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
            <Button type="button" variant="outline" size="lg" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button
              type="submit"
              variant="primary"
              size="lg"
              disabled={nameAvailable === false}
              data-testid="cta-save"
            >
              {manufacturer?.id ? "Update Manufacturer" : "Create Manufacturer"}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  );
}