
"use client";
import Link from "next/link";
import { useState } from "react";
import { ChevronDown, ChevronRight } from "lucide-react";

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

interface SidebarProps {
  items: MenuItem[];
}

export default function Sidebar({ items }: SidebarProps) {
  // Initialize with commonly used sections expanded
  const [expandedItems, setExpandedItems] = useState<Set<string>>(() => {
    const initialExpanded = new Set<string>();
    // Auto-expand sections that are commonly used
    const autoExpandSections = ["Order Management", "Master Data"];
    autoExpandSections.forEach(section => {
      if (items.some(item => item.label === section)) {
        initialExpanded.add(section);
      }
    });
    return initialExpanded;
  });

  const toggleExpanded = (label: string) => {
    const newExpanded = new Set(expandedItems);
    if (newExpanded.has(label)) {
      newExpanded.delete(label);
    } else {
      newExpanded.add(label);
    }
    setExpandedItems(newExpanded);
  };

  return (
    <aside className="w-64 border-r border-gray-200 h-full bg-white shadow-sm overflow-y-auto">
      <div className="p-3 space-y-2">
        {items.map((item) => (
          <div key={item.label} className="space-y-1">
            {/* Top-level item */}
            {item.children ? (
              <button
                onClick={() => toggleExpanded(item.label)}
                className="w-full flex items-center justify-between px-3 py-2.5 text-sm font-semibold text-gray-800 rounded-lg hover:bg-blue-50 hover:text-blue-700 transition-all duration-200 group"
              >
                <span className="flex items-center gap-3">
                  {item.icon && <span className="text-lg">{item.icon}</span>}
                  <span className="truncate">{item.label}</span>
                </span>
                {expandedItems.has(item.label) ? (
                  <ChevronDown className="h-4 w-4 text-gray-500 group-hover:text-blue-600" />
                ) : (
                  <ChevronRight className="h-4 w-4 text-gray-500 group-hover:text-blue-600" />
                )}
              </button>
            ) : (
              <Link
                href={item.href || "#"}
                className="flex items-center gap-3 px-3 py-2.5 text-sm font-semibold text-gray-800 rounded-lg hover:bg-blue-50 hover:text-blue-700 transition-all duration-200 group"
              >
                {item.icon && <span className="text-lg">{item.icon}</span>}
                <span className="truncate">{item.label}</span>
              </Link>
            )}

            {/* Sub-items */}
            {item.children && expandedItems.has(item.label) && (
              <div className="ml-3 mt-1 space-y-1 border-l-2 border-blue-100 pl-4 py-1">
                {item.children.map((subItem) => (
                  <div key={subItem.label}>
                    <Link
                      href={subItem.href}
                      className="flex items-center gap-2 px-3 py-2 text-sm text-gray-600 rounded-md hover:bg-gray-50 hover:text-gray-900 transition-all duration-150 group"
                    >
                      <span className="w-1.5 h-1.5 bg-gray-400 rounded-full group-hover:bg-blue-500 transition-colors"></span>
                      <span className="truncate">{subItem.label}</span>
                    </Link>
                  </div>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
    </aside>
  );
}
