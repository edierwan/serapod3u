import { createSupabaseServerClient } from "@/lib/supabase/server";
import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Edit, Calendar, CheckCircle, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { CATEGORY_NAME_TO_ENUM_MAP, PRODUCT_CATEGORY_OPTIONS } from "@/lib/constants/productCategories";

interface PageProps {
  params: Promise<{ id: string }>;
}

export default async function ProductGroupViewPage({ params }: PageProps) {
  const { id } = await params;
  const supabase = await createSupabaseServerClient();
  
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Check permissions
  const { data: profile } = await supabase
    .from("profiles")
    .select("role_code")
    .eq("id", user.id)
    .single();

  const canModify = profile?.role_code === "hq_admin" || profile?.role_code === "power_user";

  // Fetch product group with category
  const { data: productGroup } = await supabase
    .from("product_groups")
    .select(`
      *,
      categories:category_id (
        id,
        name
      )
    `)
    .eq("id", id)
    .single();

  if (!productGroup) {
    notFound();
  }

  // Get the user-friendly category label
  const categoryLabel = productGroup.categories?.name ? 
    PRODUCT_CATEGORY_OPTIONS.find(opt => 
      CATEGORY_NAME_TO_ENUM_MAP[productGroup.categories.name] === opt.value
    )?.label || productGroup.categories.name 
    : "No Category";

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link 
            href="/master/product-groups"
            className="inline-flex items-center gap-2 text-sm text-gray-600 hover:text-gray-900"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to Product Groups
          </Link>
        </div>
        {canModify && (
          <Link href={`/master/product-groups/${id}/edit`}>
            <Button className="inline-flex items-center gap-2">
              <Edit className="h-4 w-4" />
              Edit Product Group
            </Button>
          </Link>
        )}
      </div>

      <div className="bg-white shadow sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h1 className="text-2xl font-semibold text-gray-900 mb-6">{productGroup.name}</h1>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Category</h3>
              <span className="text-sm text-gray-900 font-medium">{categoryLabel}</span>
            </div>

            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Status</h3>
              <div className="flex items-center gap-2">
                {productGroup.is_active ? (
                  <>
                    <CheckCircle className="h-5 w-5 text-green-500" />
                    <span className="text-sm text-green-700 font-medium">Active</span>
                  </>
                ) : (
                  <>
                    <XCircle className="h-5 w-5 text-red-500" />
                    <span className="text-sm text-red-700 font-medium">Inactive</span>
                  </>
                )}
              </div>
            </div>

            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Created Date</h3>
              <div className="flex items-center gap-2">
                <Calendar className="h-4 w-4 text-gray-400" />
                <span className="text-sm text-gray-900">
                  {new Date(productGroup.created_at).toLocaleDateString()}
                </span>
              </div>
            </div>

            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Last Updated</h3>
              <div className="flex items-center gap-2">
                <Calendar className="h-4 w-4 text-gray-400" />
                <span className="text-sm text-gray-900">
                  {new Date(productGroup.updated_at).toLocaleDateString()}
                </span>
              </div>
            </div>

            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Product Group ID</h3>
              <span className="text-sm text-gray-900 font-mono">{productGroup.id}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}