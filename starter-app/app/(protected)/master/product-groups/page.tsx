import { createSupabaseServerClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import Link from "next/link";
import { Plus, Edit, Eye } from "lucide-react";
import DeleteProductGroupButton from "./DeleteProductGroupButton";
import { CATEGORY_NAME_TO_ENUM_MAP, PRODUCT_CATEGORY_OPTIONS } from "@/lib/constants/productCategories";
import { getProductGroups } from "../products/actions";
import type { ProductGroupWithCategory } from "@/lib/types/master";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";

export default async function ProductGroupsPage() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Check permissions
  const { data: profile } = await supabase
    .from("users_profile")
    .select("role_code")
    .eq("user_id", user.id)
    .single();

  const canModify = profile?.role_code === "hq_admin" || profile?.role_code === "power_user";

  // Fetch product groups with categories
  const productGroups = await getProductGroups();

  const typedProductGroups: ProductGroupWithCategory[] = productGroups;

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-gray-900">Product Groups</h1>
        {canModify && (
          <Button asChild variant="primary">
            <Link href="/master/product-groups/create">
              <Plus className="h-4 w-4" />
              Add Product Group
            </Link>
          </Button>
        )}
      </div>

      <div className="bg-white shadow overflow-hidden sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          {typedProductGroups && typedProductGroups.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Name
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Category
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Created
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {typedProductGroups.map((group) => (
                    <tr key={group.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm font-medium text-gray-900">{group.name}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="text-sm text-gray-900">
                          {group.category?.name ? 
                            PRODUCT_CATEGORY_OPTIONS.find(opt => 
                              CATEGORY_NAME_TO_ENUM_MAP[group.category!.name] === opt.value
                            )?.label || group.category.name 
                            : "No Category"
                          }
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          group.is_active 
                            ? "bg-green-100 text-green-800" 
                            : "bg-red-100 text-red-800"
                        }`}>
                          {group.is_active ? "Active" : "Inactive"}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(group.created_at!).toLocaleDateString()}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                        <Button asChild variant="outline" size="sm">
                          <Link href={`/master/product-groups/${group.id}`}>
                            <Eye className="h-4 w-4" />
                            View
                          </Link>
                        </Button>
                        {canModify && (
                          <>
                            <Button asChild variant="outline" size="sm">
                              <Link href={`/master/product-groups/${group.id}/edit`}>
                                <Edit className="h-4 w-4" />
                                Edit
                              </Link>
                            </Button>
                            <DeleteProductGroupButton 
                              groupId={group.id}
                              groupName={group.name}
                            />
                          </>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="text-center py-12">
              <EmptyState
                icon={Plus}
                title="No product groups found"
                body="Get started by creating your first product group."
                primaryCta={canModify ? {
                  label: "Create Product Group",
                  onClick: () => window.location.href = "/master/product-groups/create"
                } : undefined}
              />
            </div>
          )}
        </div>
      </div>
    </div>
  );
}