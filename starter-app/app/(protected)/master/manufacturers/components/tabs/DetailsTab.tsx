"use client";

import { useState, useTransition } from "react";
import { Edit } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { updateManufacturer } from "../../actions";
import { toast } from "sonner";

interface Manufacturer {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  address?: string;
  logo_url?: string;
  created_at: string;
  updated_at?: string;
}

interface DetailsTabProps {
  manufacturer: Manufacturer | null;
  canEdit: boolean;
}

export default function DetailsTab({ manufacturer, canEdit }: DetailsTabProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [isPending, startTransition] = useTransition();

  if (!manufacturer) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <p className="text-muted-foreground">Select a manufacturer from the list to view details</p>
        </div>
      </div>
    );
  }

  const handleUpdate = (formData: FormData) => {
    startTransition(async () => {
      const result = await updateManufacturer(formData);
      if (result.success) {
        toast.success("Changes saved.");
        setIsEditing(false);
      } else {
        toast.error(result.error || "Failed to update manufacturer");
      }
    });
  };

  if (isEditing) {
    return (
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <h2 className="text-lg font-semibold">Edit Manufacturer</h2>
        </div>
        
        <form action={handleUpdate} className="space-y-6 max-w-md">
          <input type="hidden" name="id" value={manufacturer.id} />
          <div>
            <label className="block text-sm font-medium mb-2">Name *</label>
            <Input
              name="name"
              defaultValue={manufacturer.name}
              required
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-2">Email</label>
            <Input
              name="email"
              type="email"
              defaultValue={manufacturer.email || ""}
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-2">Phone</label>
            <Input
              name="phone"
              defaultValue={manufacturer.phone || ""}
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-2">Address</label>
            <Input
              name="address"
              defaultValue={manufacturer.address || ""}
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-2">Logo URL</label>
            <Input
              name="logo_url"
              type="url"
              defaultValue={manufacturer.logo_url || ""}
            />
          </div>
          
          <div className="flex gap-2">
            <Button type="submit" disabled={isPending}>
              {isPending ? "Saving..." : "Save Changes"}
            </Button>
            <Button
              type="button"
              variant="outline"
              onClick={() => setIsEditing(false)}
            >
              Cancel
            </Button>
          </div>
        </form>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-lg font-semibold">Manufacturer Details</h2>
        {canEdit && (
          <Button onClick={() => setIsEditing(true)}>
            <Edit className="h-4 w-4 mr-2" />
            Edit
          </Button>
        )}
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
            <label className="block text-sm font-medium text-muted-foreground mb-1">Email</label>
            <p className="text-base">{manufacturer.email || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Phone</label>
            <p className="text-base">{manufacturer.phone || "Not provided"}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-muted-foreground mb-1">Address</label>
            <p className="text-base">{manufacturer.address || "Not provided"}</p>
          </div>
        </div>

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
    </div>
  );
}
