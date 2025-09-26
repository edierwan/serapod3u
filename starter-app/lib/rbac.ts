
export type Role = 'hq_admin'|'power_user'|'manufacturer'|'warehouse'|'distributor'|'shop';

export const SidebarByRole: Record<Role, Array<{label:string, href:string}>> = {
  hq_admin: [
    { label: "Dashboard", href: "/dashboard" },
    { label: "Orders", href: "/orders" },
    { label: "Purchase Orders", href: "/purchase-orders" },
    { label: "Invoices", href: "/invoices" },
    { label: "Payments", href: "/payments" },
    { label: "Receipts", href: "/receipts" },
    { label: "Tracking", href: "/tracking/movements" },
    { label: "Campaigns", href: "/campaigns/lucky-draw" },
    { label: "Master Data", href: "/master/products" },
    { label: "Notifications", href: "/notifications" },
    { label: "Settings", href: "/settings" },
  ],
  power_user: [
    { label: "Dashboard", href: "/dashboard" },
    { label: "Orders", href: "/orders" },
    { label: "Purchase Orders", href: "/purchase-orders" },
    { label: "Invoices", href: "/invoices" },
    { label: "Payments", href: "/payments" },
    { label: "Receipts", href: "/receipts" },
    { label: "Tracking", href: "/tracking/movements" },
    { label: "Campaigns", href: "/campaigns/lucky-draw" },
    { label: "Master Data", href: "/master/products" },
    { label: "Notifications", href: "/notifications" },
    { label: "Settings", href: "/settings" },
  ],
  manufacturer: [
    { label: "Dashboard", href: "/dashboard" },
    { label: "Purchase Orders", href: "/purchase-orders" },
    { label: "Settings", href: "/settings" },
  ],
  warehouse: [
    { label: "Dashboard", href: "/dashboard" },
    { label: "Tracking", href: "/tracking/movements" },
    { label: "Settings", href: "/settings" },
  ],
  distributor: [
    { label: "Dashboard", href: "/dashboard" },
    { label: "Orders", href: "/orders" },
    { label: "Tracking", href: "/tracking/movements" },
    { label: "Settings", href: "/settings" },
  ],
  shop: [
    { label: "Dashboard", href: "/dashboard" },
    { label: "Rewards", href: "/campaigns/rewards" },
    { label: "Settings", href: "/settings" },
  ],
};
