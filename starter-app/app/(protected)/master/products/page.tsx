"use client";

import { useState } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
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
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="products">Products</TabsTrigger>
          <TabsTrigger value="create">Create Product</TabsTrigger>
          <TabsTrigger value="master-data">Master Data</TabsTrigger>
        </TabsList>
        
        <TabsContent value="products" className="space-y-0">
          <ProductsList />
        </TabsContent>
        
        <TabsContent value="create" className="space-y-0">
          <ProductCreateForm />
        </TabsContent>
        
        <TabsContent value="master-data" className="space-y-0">
          <MasterDataTabs />
        </TabsContent>
      </Tabs>
    </div>
  );
}