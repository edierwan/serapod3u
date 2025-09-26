"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { TabConfig } from "@/lib/tabs";

interface TabBarProps {
  tabs: TabConfig[];
  basePath: string;
}

export default function TabBar({ tabs, basePath }: TabBarProps) {
  const pathname = usePathname();
  
  if (tabs.length === 0) return null;

  return (
    <div className="border-b border-gray-200 bg-white">
      <div className="px-4 sm:px-6 lg:px-8">
        <nav className="-mb-px flex space-x-8" aria-label="Tabs">
          {tabs.map((tab) => {
            const isActive = pathname === tab.href;
            return (
              <Link
                key={tab.id}
                href={tab.href}
                className={`
                  whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm transition-colors duration-200
                  ${isActive
                    ? "border-blue-500 text-blue-600"
                    : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
                  }
                `}
                aria-current={isActive ? "page" : undefined}
              >
                {tab.label}
              </Link>
            );
          })}
        </nav>
      </div>
    </div>
  );
}