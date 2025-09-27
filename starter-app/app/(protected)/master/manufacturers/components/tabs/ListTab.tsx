"use client";

import { useState, useTransition } from "react";
import { Search, Edit, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { deleteManufacturer } from "../../actions";
import { toast } from "sonner";

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

interface ListTabProps {
  manufacturers: Manufacturer[];
  onSelectManufacturer: (id: string) => void;
}

export default function ListTab({ manufacturers, onSelectManufacturer }: ListTabProps) {
  const [searchQuery, setSearchQuery] = useState("");
  const [, startTransition] = useTransition();

  const filteredManufacturers = manufacturers.filter(manufacturer =>
    manufacturer.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    manufacturer.email?.toLowerCase().includes(searchQuery.toLowerCase()) ||
    manufacturer.country_code?.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleDelete = (id: string) => {
    if (!confirm("Are you sure you want to delete this manufacturer?")) return;
    startTransition(async () => {
      const result = await deleteManufacturer(id);
      if (result.success) {
        toast.success("Manufacturer deleted successfully.");
      } else {
        toast.error(result.error || "Failed to delete manufacturer");
      }
    });
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <h2 className="text-lg font-semibold">Manufacturers List</h2>
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
                <th className="text-left p-4 font-medium">Country</th>
                <th className="text-left p-4 font-medium">Phone</th>
                <th className="text-left p-4 font-medium">Email</th>
                <th className="text-left p-4 font-medium">Status</th>
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
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <Avatar className="h-8 w-8">
                        {manufacturer.logo_url ? (
                          <AvatarImage src={`${manufacturer.logo_url}?v=${manufacturer.updated_at ?? ""}`} alt={manufacturer.name} />
                        ) : (
                          <AvatarFallback>{manufacturer.name?.slice(0,2).toUpperCase()}</AvatarFallback>
                        )}
                      </Avatar>
                      <span className="truncate">{manufacturer.name}</span>
                    </div>
                  </td>
                  <td className="p-4 text-muted-foreground">{manufacturer.country_code || "-"}</td>
                  <td className="p-4 text-muted-foreground">{manufacturer.phone || "-"}</td>
                  <td className="p-4 text-muted-foreground">{manufacturer.email || "-"}</td>
                  <td className="p-4">
                    <Badge variant={manufacturer.is_active ? "default" : "secondary"}>
                      {manufacturer.is_active ? "Active" : "Inactive"}
                    </Badge>
                  </td>
                  <td className="p-4">
                    <div className="flex gap-2">
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={(e: React.MouseEvent<HTMLButtonElement>) => {
                          e.stopPropagation();
                          onSelectManufacturer(manufacturer.id);
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

      {filteredManufacturers.length === 0 && (
        <div className="text-center py-8">
          <p className="text-muted-foreground">No manufacturers found.</p>
        </div>
      )}
    </div>
  );
}
