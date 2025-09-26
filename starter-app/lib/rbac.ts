
export type Role = 'hq_admin'|'power_user'|'manufacturer'|'warehouse'|'distributor'|'shop';

interface SubMenuItem {
  label: string;
  href: string;
}

interface MenuItem {
  label: string;
  href?: string;
  icon?: string;
  children?: SubMenuItem[];
}

export const SidebarByRole: Record<Role, MenuItem[]> = {
  hq_admin: [
    { 
      label: "Dashboard", 
      href: "/dashboard", 
      icon: "🏠" 
    },
    {
      label: "Order Management",
      icon: "📂",
      children: [
        { 
          label: "Orders", 
          href: "/orders"
        },
        { 
          label: "Purchase Orders", 
          href: "/purchase-orders"
        },
        { 
          label: "Invoices", 
          href: "/invoices"
        },
        { 
          label: "Payments", 
          href: "/payments"
        },
        { 
          label: "Receipts", 
          href: "/receipts"
        }
      ]
    },
    {
      label: "Tracking",
      icon: "📍",
      children: [
        { 
          label: "Case Movements", 
          href: "/tracking/movements"
        },
        { 
          label: "Scan History", 
          href: "/tracking/scan-history"
        },
        { 
          label: "Blocked/Returned", 
          href: "/tracking/blocked-returned"
        }
      ]
    },
    {
      label: "Campaigns & Rewards",
      icon: "🎯",
      children: [
        { 
          label: "🎲 Lucky Draw", 
          href: "/campaigns/lucky-draw"
        },
        { 
          label: "🎁 Redeem", 
          href: "/campaigns/redeem"
        },
        { 
          label: "⭐ Rewards (Points)", 
          href: "/campaigns/rewards"
        }
      ]
    },
    {
      label: "Master Data",
      icon: "⚙️",
      children: [
        { 
          label: "Products", 
          href: "/master/products"
        },
        { 
          label: "Manufacturers", 
          href: "/master/manufacturers"
        },
        { 
          label: "Distributors", 
          href: "/master/distributors"
        },
        { 
          label: "Shops", 
          href: "/master/shops"
        },
        { 
          label: "Campaign Config", 
          href: "/master/campaign-config"
        }
      ]
    },
    { 
      label: "Notifications", 
      href: "/notifications", 
      icon: "🔔" 
    },
    { 
      label: "My Profile", 
      href: "/profile", 
      icon: "👤" 
    },
    { 
      label: "Settings", 
      href: "/settings", 
      icon: "⚙️" 
    }
  ],
  power_user: [
    { 
      label: "Dashboard", 
      href: "/dashboard", 
      icon: "🏠" 
    },
    {
      label: "Order Management",
      icon: "📂",
      children: [
        { 
          label: "Orders", 
          href: "/orders"
        },
        { 
          label: "Purchase Orders", 
          href: "/purchase-orders"
        },
        { 
          label: "Invoices", 
          href: "/invoices"
        },
        { 
          label: "Payments", 
          href: "/payments"
        },
        { 
          label: "Receipts", 
          href: "/receipts"
        }
      ]
    },
    {
      label: "Tracking",
      icon: "📍",
      children: [
        { 
          label: "Case Movements", 
          href: "/tracking/movements"
        },
        { 
          label: "Scan History", 
          href: "/tracking/scan-history"
        },
        { 
          label: "Blocked/Returned", 
          href: "/tracking/blocked-returned"
        }
      ]
    },
    {
      label: "Campaigns & Rewards",
      icon: "🎯",
      children: [
        { 
          label: "🎲 Lucky Draw", 
          href: "/campaigns/lucky-draw"
        },
        { 
          label: "🎁 Redeem", 
          href: "/campaigns/redeem"
        },
        { 
          label: "⭐ Rewards (Points)", 
          href: "/campaigns/rewards"
        }
      ]
    },
    {
      label: "Master Data",
      icon: "⚙️",
      children: [
        { 
          label: "Products", 
          href: "/master/products"
        },
        { 
          label: "Manufacturers", 
          href: "/master/manufacturers"
        },
        { 
          label: "Distributors", 
          href: "/master/distributors"
        },
        { 
          label: "Shops", 
          href: "/master/shops"
        },
        { 
          label: "Campaign Config", 
          href: "/master/campaign-config"
        }
      ]
    },
    { 
      label: "Notifications", 
      href: "/notifications", 
      icon: "🔔" 
    },
    { 
      label: "My Profile", 
      href: "/profile", 
      icon: "👤" 
    },
    { 
      label: "Settings", 
      href: "/settings", 
      icon: "⚙️" 
    }
  ],
  manufacturer: [
    { 
      label: "Dashboard", 
      href: "/dashboard", 
      icon: "🏠" 
    },
    { 
      label: "Purchase Orders", 
      href: "/purchase-orders", 
      icon: "📂" 
    },
    { 
      label: "My Profile", 
      href: "/profile", 
      icon: "👤" 
    },
    { 
      label: "Settings", 
      href: "/settings", 
      icon: "⚙️" 
    }
  ],
  warehouse: [
    { 
      label: "Dashboard", 
      href: "/dashboard", 
      icon: "🏠" 
    },
    {
      label: "Tracking",
      icon: "📍",
      children: [
        { 
          label: "Case Movements", 
          href: "/tracking/movements"
        },
        { 
          label: "Scan History", 
          href: "/tracking/scan-history"
        }
      ]
    },
    { 
      label: "My Profile", 
      href: "/profile", 
      icon: "👤" 
    },
    { 
      label: "Settings", 
      href: "/settings", 
      icon: "⚙️" 
    }
  ],
  distributor: [
    { 
      label: "Dashboard", 
      href: "/dashboard", 
      icon: "🏠" 
    },
    { 
      label: "Orders", 
      href: "/orders", 
      icon: "📂" 
    },
    {
      label: "Tracking",
      icon: "📍",
      children: [
        { 
          label: "Case Movements", 
          href: "/tracking/movements"
        }
      ]
    },
    { 
      label: "My Profile", 
      href: "/profile", 
      icon: "👤" 
    },
    { 
      label: "Settings", 
      href: "/settings", 
      icon: "⚙️" 
    }
  ],
  shop: [
    { 
      label: "Dashboard", 
      href: "/dashboard", 
      icon: "🏠" 
    },
    { 
      label: "⭐ Rewards (Points)", 
      href: "/campaigns/rewards", 
      icon: "🎯" 
    },
    { 
      label: "My Profile", 
      href: "/profile", 
      icon: "👤" 
    },
    { 
      label: "Settings", 
      href: "/settings", 
      icon: "⚙️" 
    }
  ]
};
