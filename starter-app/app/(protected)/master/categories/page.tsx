import { createSSRClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import Link from "next/link";

export default async function CategoriesPage() {
  const supabase = createSSRClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Fetch categories
  const { data: categories } = await supabase
    .from("categories")
    .select("*")
    .order("name");

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Categories</h1>
        <Link 
          href="/master/categories/create"
          className="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          Add Category
        </Link>
      </div>

      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {categories?.map((category) => (
            <li key={category.id}>
              <div className="px-4 py-4 flex items-center justify-between">
                <div className="flex flex-col">
                  <p className="text-sm font-medium text-gray-900">{category.name}</p>
                  <p className="text-sm text-gray-500">
                    Status: {category.is_active ? "Active" : "Inactive"}
                  </p>
                </div>
                <div className="flex space-x-2">
                  <Link 
                    href={`/master/categories/${category.id}/edit`}
                    className="text-blue-600 hover:text-blue-900"
                  >
                    Edit
                  </Link>
                  <span className="text-gray-300">|</span>
                  <Link 
                    href={`/master/categories/${category.id}`}
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

      {!categories?.length && (
        <div className="text-center py-12">
          <p className="text-gray-500">No categories found</p>
          <Link 
            href="/master/categories/create"
            className="mt-2 inline-flex items-center px-4 py-2 text-sm font-medium text-blue-600 hover:text-blue-700"
          >
            Create your first category
          </Link>
        </div>
      )}
    </div>
  );
}