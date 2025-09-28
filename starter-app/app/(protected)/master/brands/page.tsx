import { createSupabaseServerClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { Plus } from "lucide-react";

export default async function BrandsPage() {
  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Fetch brands
  const { data: brands } = await supabase
    .from("brands")
    .select("*")
    .order("name");

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Brands</h1>
        <Button asChild variant="primary">
          <Link href="/master/brands/create">
            <Plus className="h-4 w-4 mr-2" />
            Add Brand
          </Link>
        </Button>
      </div>

      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {brands?.map((brand) => (
            <li key={brand.id}>
              <div className="px-4 py-4 flex items-center justify-between">
                <div className="flex flex-col">
                  <p className="text-sm font-medium text-gray-900">{brand.name}</p>
                  <p className="text-sm text-gray-500">
                    Status: {brand.is_active ? "Active" : "Inactive"}
                  </p>
                </div>
                <div className="flex space-x-2">
                  <Link 
                    href={`/master/brands/${brand.id}/edit`}
                    className="text-blue-600 hover:text-blue-900"
                  >
                    Edit
                  </Link>
                  <span className="text-gray-300">|</span>
                  <Link 
                    href={`/master/brands/${brand.id}`}
                    className="text-green-600 hover:text-green-900"
                  >
                    View
                  </Link>
                </div>
              </div>
            </li>
          ))}
        </ul>
      </div>

      {!brands?.length && (
        <EmptyState
          icon={Plus}
          title="No brands found"
          body="Get started by creating your first brand."
          primaryCta={{
            label: "Create Brand",
            onClick: () => window.location.href = "/master/brands/create"
          }}
        />
      )}
    </div>
  );
}