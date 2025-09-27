import { useState, useEffect, useTransition } from "react";
import { Search, Edit, Trash2, Package } from "lucide-react";
import Image from "next/image";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { getProducts, deleteProduct } from "@/app/(protected)/master/products/actions";
import { toast } from "sonner";

interface Product {
  id: string;
  name: string;
  sku: string;
  price: number;
  status: string;
  image_url: string | null;
  category: { name: string }[] | null;
  brand: { name: string }[] | null;
  group: { name: string }[] | null;
  sub_group: { name: string }[] | null;
  manufacturer: { name: string }[] | null;
}

export default function ProductsList() {
  const [products, setProducts] = useState<Product[]>([]);
  const [filteredProducts, setFilteredProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [isPending, startTransition] = useTransition();

  useEffect(() => {
    loadProducts();
  }, []);

  useEffect(() => {
    let filtered = products;

    // Search filter
    if (searchTerm) {
      filtered = filtered.filter(product =>
        product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        product.sku.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }

    // Status filter
    if (statusFilter !== "all") {
      filtered = filtered.filter(product => product.status === statusFilter);
    }

    setFilteredProducts(filtered);
  }, [products, searchTerm, statusFilter]);

  const loadProducts = async () => {
    try {
      setLoading(true);
      const data = await getProducts();
      setProducts(data);
    } catch {
      toast.error("Failed to load products");
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = (id: string, name: string) => {
    if (confirm(`Are you sure you want to delete "${name}"?`)) {
      startTransition(async () => {
        const result = await deleteProduct(id);
        if (result.ok) {
          toast.success("Product deleted successfully");
          loadProducts();
        } else {
          toast.error(result.message || "Failed to delete product");
        }
      });
    }
  };

  const getInitials = (name: string) => {
    return name
      .split(" ")
      .map(word => word[0])
      .join("")
      .toUpperCase()
      .slice(0, 2);
  };

  if (loading) {
    return (
      <div className="bg-gradient-to-br from-white via-blue-50/30 to-indigo-50/20 border-0 shadow-xl shadow-blue-500/5 rounded-lg">
        <div className="p-6 pb-4">
          <div className="animate-pulse space-y-4">
            <div className="h-6 bg-slate-200 rounded w-1/4"></div>
            <div className="space-y-3">
              {[...Array(5)].map((_, i) => (
                <div key={i} className="h-16 bg-slate-200 rounded"></div>
              ))}
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-gradient-to-br from-white via-blue-50/30 to-indigo-50/20 border-0 shadow-xl shadow-blue-500/5 rounded-lg">
      <div className="p-6 pb-4">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <h2 className="text-xl font-bold text-slate-800 flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center shadow-lg">
              <Package className="h-5 w-5 text-white" />
            </div>
            Products ({filteredProducts.length})
          </h2>

          <div className="flex flex-col sm:flex-row gap-3">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-400 h-4 w-4" />
              <Input
                type="text"
                placeholder="Search products..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10 w-full sm:w-64 bg-white/80 backdrop-blur-sm border-slate-200 focus:border-blue-400 focus:ring-blue-400/20"
              />
            </div>

            <Select value={statusFilter} onValueChange={setStatusFilter}>
              <SelectTrigger className="w-full sm:w-32 bg-white/80 backdrop-blur-sm border-slate-200">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Status</SelectItem>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="inactive">Inactive</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
      </div>

      <div className="px-6 pb-6">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gradient-to-r from-slate-50 to-slate-100/80 border-b border-slate-200/60">
              <tr>
                <th className="px-6 py-4 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Product
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  SKU
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Price
                </th>
                <th className="px-6 py-4 text-left text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-4 text-right text-xs font-semibold text-slate-600 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-200/40">
              {filteredProducts.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-6 py-12 text-center">
                    <div className="flex flex-col items-center gap-3">
                      <div className="w-12 h-12 rounded-full bg-slate-100 flex items-center justify-center">
                        <Search className="h-6 w-6 text-slate-400" />
                      </div>
                      <p className="text-slate-500 font-medium">
                        {searchTerm || statusFilter !== "all" ? "No products match your filters" : "No products found"}
                      </p>
                      <p className="text-slate-400 text-sm">Try adjusting your search or filters</p>
                    </div>
                  </td>
                </tr>
              ) : (
                filteredProducts.map((product) => (
                  <tr
                    key={product.id}
                    className="hover:bg-gradient-to-r hover:from-blue-50/50 hover:to-indigo-50/30 transition-colors duration-150"
                  >
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="flex-shrink-0 h-12 w-12">
                          {product.image_url ? (
                            <Image
                              src={product.image_url}
                              alt={product.name}
                              width={48}
                              height={48}
                              className="h-12 w-12 rounded-lg object-cover border border-slate-200 shadow-sm"
                            />
                          ) : (
                            <div className="h-12 w-12 rounded-lg bg-gradient-to-br from-slate-200 to-slate-300 flex items-center justify-center shadow-sm">
                              <span className="text-sm font-semibold text-slate-600">
                                {getInitials(product.name)}
                              </span>
                            </div>
                          )}
                        </div>
                        <div>
                          <div className="font-medium text-slate-900">{product.name}</div>
                          <div className="text-sm text-slate-500">
                            {product.category?.[0]?.name} • {product.brand?.[0]?.name}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className="font-mono text-sm font-medium text-slate-900 bg-slate-100 px-2 py-1 rounded">
                        {product.sku}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="font-semibold text-slate-900">
                        {product.price ? `$${product.price.toFixed(2)}` : "—"}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <Badge
                        variant={product.status === "active" ? "default" : "secondary"}
                        className={
                          product.status === "active"
                            ? "bg-gradient-to-r from-green-500 to-emerald-500 text-white border-0 shadow-sm"
                            : "bg-gradient-to-r from-slate-400 to-slate-500 text-white border-0 shadow-sm"
                        }
                      >
                        {product.status}
                      </Badge>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => {
                            // TODO: Implement edit functionality
                            toast.info("Edit functionality coming soon");
                          }}
                          className="bg-white hover:bg-blue-50 hover:border-blue-300 hover:text-blue-600 border-slate-200 transition-colors shadow-sm"
                        >
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => handleDelete(product.id, product.name)}
                          disabled={isPending}
                          className="bg-white hover:bg-red-50 hover:border-red-300 hover:text-red-600 border-slate-200 transition-colors shadow-sm"
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}