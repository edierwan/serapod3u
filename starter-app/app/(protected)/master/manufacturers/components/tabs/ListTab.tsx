"use client";

import { useState, useTransition } from "react";
import { Search, Plus, Edit, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createManufacturer, updateManufacturer, deleteManufacturer } from "../actions";
import { toast } from "sonner";

interface Manufacturer {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  address?: string;
  logo_url?: string;
  created_at: string;
}

interface ListTabProps {
  manufacturers: Manufacturer[];
  onSelectManufacturer: (id: string) => void;
}

export default function ListTab({ manufacturers, onSelectManufacturer }: ListTabProps) {
  const [searchQuery, setSearchQuery] = useState("");
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [editingManufacturer, setEditingManufacturer] = useState<Manufacturer | null>(null);
  const [isPending, startTransition] = useTransition();

  const filteredManufacturers = manufacturers.filter(manufacturer =>
    manufacturer.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    manufacturer.email?.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleCreate = (formData: FormData) => {
    startTransition(async () => {
      const result = await createManufacturer(formData);
      if (result.ok) {
        toast.success("Saved successfully.");
        setShowCreateDialog(false);
      } else {
        toast.error(result.message);
      }
    });
  };

  const handleUpdate = (formData: FormData) => {
    if (!editingManufacturer) return;
    startTransition(async () => {
      const result = await updateManufacturer(editingManufacturer.id, formData);
      if (result.ok) {
        toast.success("Changes saved.");
        setEditingManufacturer(null);
      } else {
        toast.error(result.message);
      }
    });
  };

  const handleDelete = (id: string) => {
    if (!confirm("Are you sure you want to delete this manufacturer?")) return;
    startTransition(async () => {
      const result = await deleteManufacturer(id);
      if (result.ok) {
        toast.success("Deleted.");
      } else {
        toast.error(result.message);
      }
    });
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <h2 className="text-lg font-semibold">Manufacturers List</h2>
        <Button onClick={() => setShowCreateDialog(true)}>
          <Plus className="h-4 w-4 mr-2" />
          Add Manufacturer
        </Button>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground h-4 w-4" />
        <Input
          placeholder="Search manufacturers..."
          value={searchQuery}
          onChange={(e: React.ChangeEvent<HTMLInputElement>) => setSearchQuery(e.target.value)}
          className="pl-10"
        />
      </div>

      {/* Table */}
      <div className="border border-border rounded-lg bg-white overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left p-4 font-medium">Name</th>
                <th className="text-left p-4 font-medium">Email</th>
                <th className="text-left p-4 font-medium">Phone</th>
                <th className="text-left p-4 font-medium">Created</th>
                <th className="text-left p-4 font-medium">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredManufacturers.map((manufacturer) => (
                <tr
                  key={manufacturer.id}
                  className="border-t border-border hover:bg-muted/25 cursor-pointer"
                  onClick={() => onSelectManufacturer(manufacturer.id)}
                >
                  <td className="p-4 font-medium">{manufacturer.name}</td>
                  <td className="p-4 text-muted-foreground">{manufacturer.email || "-"}</td>
                  <td className="p-4 text-muted-foreground">{manufacturer.phone || "-"}</td>
                  <td className="p-4 text-muted-foreground">
                    {new Date(manufacturer.created_at).toLocaleDateString()}
                  </td>
                  <td className="p-4">
                    <div className="flex gap-2">
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={(e: React.MouseEvent<HTMLButtonElement>) => {
                          e.stopPropagation();
                          setEditingManufacturer(manufacturer);
                        }}
                      >
                        <Edit className="h-4 w-4" />
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={(e: React.MouseEvent<HTMLButtonElement>) => {
                          e.stopPropagation();
                          handleDelete(manufacturer.id);
                        }}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Create/Edit Dialog */}
      {(showCreateDialog || editingManufacturer) && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-lg w-full max-w-md mx-4">
            <h3 className="text-lg font-semibold mb-4">
              {editingManufacturer ? "Edit Manufacturer" : "Create Manufacturer"}
            </h3>
            <form
              action={editingManufacturer ? handleUpdate : handleCreate}
              className="space-y-4"
            >
              <div>
                <label className="block text-sm font-medium mb-1">Name *</label>
                <Input
                  name="name"
                  defaultValue={editingManufacturer?.name || ""}
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Email</label>
                <Input
                  name="email"
                  type="email"
                  defaultValue={editingManufacturer?.email || ""}
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Phone</label>
                <Input
                  name="phone"
                  defaultValue={editingManufacturer?.phone || ""}
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Address</label>
                <Input
                  name="address"
                  defaultValue={editingManufacturer?.address || ""}
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Logo URL</label>
                <Input
                  name="logo_url"
                  type="url"
                  defaultValue={editingManufacturer?.logo_url || ""}
                />
              </div>
              <div className="flex gap-2 pt-4">
                <Button type="submit" disabled={isPending}>
                  {isPending ? "Saving..." : "Save"}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setShowCreateDialog(false);
                    setEditingManufacturer(null);
                  }}
                >
                  Cancel
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}