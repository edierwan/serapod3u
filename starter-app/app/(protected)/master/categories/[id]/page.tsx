import { createSupabaseServerClient } from "@/lib/supabase/server";
import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Edit, Calendar, CheckCircle, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";

interface PageProps {
  params: Promise<{ id: string }>;
}

export default async function CategoryViewPage({ params }: PageProps) {
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

  // Fetch category
  const { data: category } = await supabase
    .from("categories")
    .select("*")
    .eq("id", id)
    .single();

  if (!category) {
    notFound();
  }

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link 
            href="/master/categories"
            className="inline-flex items-center gap-2 text-sm text-gray-600 hover:text-gray-900"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to Categories
          </Link>
        </div>
        {canModify && (
          <Link href={`/master/categories/${id}/edit`}>
            <Button className="inline-flex items-center gap-2">
              <Edit className="h-4 w-4" />
              Edit Category
            </Button>
          </Link>
        )}
      </div>

      <div className="bg-white shadow sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h1 className="text-2xl font-semibold text-gray-900 mb-6">{category.name}</h1>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Status</h3>
              <div className="flex items-center gap-2">
                {category.is_active ? (
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
                  {new Date(category.created_at).toLocaleDateString()}
                </span>
              </div>
            </div>

            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Last Updated</h3>
              <div className="flex items-center gap-2">
                <Calendar className="h-4 w-4 text-gray-400" />
                <span className="text-sm text-gray-900">
                  {new Date(category.updated_at).toLocaleDateString()}
                </span>
              </div>
            </div>

            <div>
              <h3 className="text-sm font-medium text-gray-500 mb-2">Category ID</h3>
              <span className="text-sm text-gray-900 font-mono">{category.id}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}