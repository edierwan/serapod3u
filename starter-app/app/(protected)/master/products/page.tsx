"use client";

import { useState } from "react";
import { Tabs, TabsContent } from "@/components/ui/oval-tabs";
import { OvalTabsList, OvalTab } from "@/components/ui/oval-tabs";
import { Package, Plus, Database } from "lucide-react";
import { ProductsList, ProductCreateForm, MasterDataTabs } from "@/components/products";

export default function ProductsPage() {
  const [activeTab, setActiveTab] = useState("products");

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Products</h1>
        <p className="mt-1 text-sm text-gray-500">
          Manage products, create new items, and maintain master data
        </p>
      </div>
      
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <OvalTabsList size="lg" layout="grid" className="w-full">
          <OvalTab value="products" size="lg" className="w-full justify-center">
            <Package className="h-4 w-4 opacity-80 data-[state=active]:opacity-100" />
            <span className="tracking-[0.01em]">Products</span>
          </OvalTab>
          <OvalTab value="create" size="lg" className="w-full justify-center">
            <Plus className="h-4 w-4 opacity-80 data-[state=active]:opacity-100" />
            <span className="tracking-[0.01em]">Create Product</span>
          </OvalTab>
          <OvalTab value="master-data" size="lg" className="w-full justify-center">
            <Database className="h-4 w-4 opacity-80 data-[state=active]:opacity-100" />
            <span className="tracking-[0.01em]">Master Data</span>
          </OvalTab>
        </OvalTabsList>
        
        <TabsContent value="products" className="space-y-0">
          <ProductsList />
        </TabsContent>
        
        <TabsContent value="create" className="space-y-0">
          <ProductCreateForm 
            onSuccess={() => setActiveTab("master-data")}
            onCancel={() => setActiveTab("products")}
          />
        </TabsContent>
        
        <TabsContent value="master-data" className="space-y-0">
          <MasterDataTabs onCreateProduct={() => setActiveTab("create")} />
        </TabsContent>
      </Tabs>
    </div>
  );
}