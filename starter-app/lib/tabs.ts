export interface TabConfig {
  id: string;
  label: string;
  href: string;
}

export interface PageTabConfig {
  [key: string]: TabConfig[];
}

export const PAGE_TABS: PageTabConfig = {
  // Order Management
  "/orders": [
    { id: "approval", label: "Approval", href: "/orders/approval" },
    { id: "list", label: "List", href: "/orders/list" }
  ],
  "/purchase-orders": [
    { id: "list", label: "PO List", href: "/purchase-orders" },
    { id: "acknowledge", label: "Acknowledge", href: "/purchase-orders/acknowledge" }
  ],
  "/invoices": [
    { id: "list", label: "Invoice List", href: "/invoices" },
    { id: "download", label: "Download/Print", href: "/invoices/download" }
  ],
  "/payments": [
    { id: "upload", label: "Upload Proof", href: "/payments" },
    { id: "verification", label: "Verification", href: "/payments/verification" },
    { id: "history", label: "History", href: "/payments/history" }
  ],
  "/receipts": [
    { id: "list", label: "Receipt List", href: "/receipts" },
    { id: "download", label: "Download/Print", href: "/receipts/download" }
  ],

  // Tracking
  "/tracking/movements": [
    { id: "inbound", label: "Inbound", href: "/tracking/movements" },
    { id: "outbound", label: "Outbound", href: "/tracking/movements/outbound" }
  ],
  "/tracking/scan-history": [
    { id: "batch", label: "By Batch", href: "/tracking/scan-history" },
    { id: "case", label: "By Case", href: "/tracking/scan-history/case" }
  ],
  "/tracking/blocked-returned": [
    { id: "blocked", label: "Blocked", href: "/tracking/blocked-returned" },
    { id: "returned", label: "Returned", href: "/tracking/blocked-returned/returned" }
  ],

  // Campaigns & Rewards
  "/campaigns/lucky-draw": [
    { id: "campaigns", label: "Campaigns", href: "/campaigns/lucky-draw" },
    { id: "entries", label: "Entries", href: "/campaigns/lucky-draw/entries" },
    { id: "results", label: "Results", href: "/campaigns/lucky-draw/results" }
  ],
  "/campaigns/redeem": [
    { id: "campaigns", label: "Campaigns", href: "/campaigns/redeem" },
    { id: "logs", label: "Redemption Logs", href: "/campaigns/redeem/logs" }
  ],
  "/campaigns/rewards": [
    { id: "ledger", label: "Ledger", href: "/campaigns/rewards" },
    { id: "rules", label: "Rules", href: "/campaigns/rewards/rules" },
    { id: "reports", label: "Reports", href: "/campaigns/rewards/reports" }
  ],

  // Master Data
  "/master/products": [
    { id: "categories", label: "Categories", href: "/master/products" },
    { id: "groups", label: "Groups", href: "/master/products/groups" },
    { id: "sub-types", label: "Sub‑Types", href: "/master/products/sub-types" },
    { id: "items", label: "Items", href: "/master/products/items" },
    { id: "variants", label: "Variants", href: "/master/products/variants" }
  ],
  "/master/manufacturers": [
    { id: "list", label: "List", href: "/master/manufacturers" },
    { id: "details", label: "Details", href: "/master/manufacturers/details" }
  ],
  "/master/distributors": [
    { id: "list", label: "List", href: "/master/distributors" },
    { id: "shops", label: "Shops Management", href: "/master/distributors/shops" }
  ],
  "/master/shops": [
    { id: "list", label: "List", href: "/master/shops" },
    { id: "points", label: "Points Balance", href: "/master/shops/points" }
  ],
  "/master/campaign-config": [
    { id: "lucky-draw", label: "Lucky Draw", href: "/master/campaign-config" },
    { id: "redeem", label: "Redeem", href: "/master/campaign-config/redeem" },
    { id: "rewards", label: "Rewards", href: "/master/campaign-config/rewards" }
  ]
};

// Helper function to get tabs for a specific page
export function getPageTabs(pathname: string): TabConfig[] {
  return PAGE_TABS[pathname] || [];
}

// Helper function to get the active tab based on current pathname
export function getActiveTab(basePath: string, currentPath: string): string {
  const tabs = PAGE_TABS[basePath];
  if (!tabs) return "";
  
  const activeTab = tabs.find(tab => tab.href === currentPath);
  return activeTab?.id || tabs[0]?.id || "";
}