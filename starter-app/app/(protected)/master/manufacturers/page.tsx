import { createSSRClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import Link from "next/link";

export default async function ManufacturersPage() {
  const supabase = createSSRClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Fetch manufacturers
  const { data: manufacturers } = await supabase
    .from("manufacturers")
    .select("*")
    .order("name");

  return (
    <div className="max-w-6xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Manufacturers</h1>
        <Link 
          href="/master/manufacturers/create"
          className="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          Add Manufacturer
        </Link>
      </div>

      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {manufacturers?.map((manufacturer) => (
            <li key={manufacturer.id}>
              <div className="px-4 py-4 flex items-center justify-between">
                <div className="flex flex-col">
                  <p className="text-sm font-medium text-gray-900">{manufacturer.name}</p>
                  <p className="text-sm text-gray-500">
                    Status: {manufacturer.is_active ? "Active" : "Inactive"}
                  </p>
                </div>
                <div className="flex space-x-2">
                  <Link 
                    href={`/master/manufacturers/${manufacturer.id}/edit`}
                    className="text-blue-600 hover:text-blue-900"
                  >
                    Edit
                  </Link>
                  <span className="text-gray-300">|</span>
                  <Link 
                    href={`/master/manufacturers/${manufacturer.id}`}
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

      {!manufacturers?.length && (
        <div className="text-center py-12">
          <p className="text-gray-500">No manufacturers found</p>
          <Link 
            href="/master/manufacturers/create"
            className="mt-2 inline-flex items-center px-4 py-2 text-sm font-medium text-blue-600 hover:text-blue-700"
          >
            Create your first manufacturer
          </Link>
        </div>
      )}
    </div>
  );
}