"use client";

import React, { useTransition } from "react";
import { toast } from "sonner";
import { addPointsLedgerEntry } from "./actions";

interface Shop {
  id: string;
  name: string;
  distributor_id: string;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
  distributors?: { name: string };
}

interface Balance {
  shop_id: string;
  points: number;
}

interface PointsClientProps {
  shops: Shop[];
  balances: Balance[];
}

export default function PointsClient({ shops, balances }: PointsClientProps) {
  const [isPending, startTransition] = useTransition();

  const handleAddLedgerEntry = (formData: FormData) => {
    startTransition(async () => {
      const result = await addPointsLedgerEntry(formData);
      if (result.success) {
        toast.success("Points ledger entry added successfully");
        // Reset form
        const form = document.querySelector("form") as HTMLFormElement;
        form?.reset();
      } else {
        toast.error(result.error || "Failed to add points ledger entry");
      }
    });
  };

  // Create a map of shop_id to points for quick lookup
  const pointsMap = balances.reduce((acc, balance) => {
    acc[balance.shop_id] = balance.points;
    return acc;
  }, {} as Record<string, number>);

  return (
    <div>
      {/* + Add Points Ledger Entry Form */}
      <div className="bg-white p-4 rounded-lg shadow mb-6">
        <h2 className="text-lg font-semibold mb-4">+ Add Points Ledger Entry</h2>
        <form action={handleAddLedgerEntry} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label htmlFor="shop_id" className="block text-sm font-medium text-gray-700">
                Shop *
              </label>
              <select
                id="shop_id"
                name="shop_id"
                required
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              >
                <option value="">Select Shop</option>
                {shops.map((shop) => (
                  <option key={shop.id} value={shop.id}>
                    {shop.name} ({shop.distributors?.name || "No Distributor"})
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label htmlFor="delta" className="block text-sm font-medium text-gray-700">
                Points Delta *
              </label>
              <input
                type="number"
                id="delta"
                name="delta"
                required
                placeholder="Positive or negative number"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="reason" className="block text-sm font-medium text-gray-700">
                Reason
              </label>
              <input
                type="text"
                id="reason"
                name="reason"
                placeholder="Optional reason"
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>
            <div className="flex items-end">
              <button
                type="submit"
                disabled={isPending}
                className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50"
              >
                {isPending ? "Adding..." : "Add Entry"}
              </button>
            </div>
          </div>
        </form>
      </div>

      {/* Points Balance Table */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <div className="px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-medium text-gray-900">Points Balance</h3>
        </div>
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Shop Name
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Distributor
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Points Balance
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Status
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {shops.map((shop) => {
              const points = pointsMap[shop.id] || 0;
              return (
                <tr key={shop.id}>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    {shop.name}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {shop.distributors?.name || "N/A"}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    <span className={`font-semibold ${points >= 0 ? "text-green-600" : "text-red-600"}`}>
                      {points.toLocaleString()} points
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span
                      className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                        shop.is_active
                          ? "bg-green-100 text-green-800"
                          : "bg-red-100 text-red-800"
                      }`}
                    >
                      {shop.is_active ? "Active" : "Inactive"}
                    </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
        {shops.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            No shops found.
          </div>
        )}
      </div>
    </div>
  );
}