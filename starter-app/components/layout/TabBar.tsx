"use client";
import { usePathname } from "next/navigation";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { TabConfig } from "@/lib/tabs";
import { useRouter } from "next/navigation";
import { 
  Plus, 
  List, 
  CheckCircle, 
  FileText, 
  CreditCard, 
  Receipt,
  Package,
  History,
  AlertTriangle,
  Dice6,
  Gift,
  Star,
  Tag,
  Users,
  Store,
  Settings
} from "lucide-react";

interface TabBarProps {
  tabs: TabConfig[];
  children?: React.ReactNode;
}

// Icon mapping for different tab types
const getIconForTab = (tabId: string, label: string) => {
  const iconProps = { className: "h-4 w-4" };
  
  // Specific mappings based on tab ID and label
  switch (tabId) {
    case "create": return <Plus {...iconProps} />;
    case "approval": return <CheckCircle {...iconProps} />;
    case "list": return <List {...iconProps} />;
    case "acknowledge": return <CheckCircle {...iconProps} />;
    case "download": return <FileText {...iconProps} />;
    case "upload": return <Plus {...iconProps} />;
    case "verification": return <CheckCircle {...iconProps} />;
    case "history": return <History {...iconProps} />;
    case "inbound": return <Package {...iconProps} />;
    case "outbound": return <Package {...iconProps} />;
    case "batch": return <Package {...iconProps} />;
    case "case": return <Package {...iconProps} />;
    case "blocked": return <AlertTriangle {...iconProps} />;
    case "returned": return <AlertTriangle {...iconProps} />;
    case "campaigns": return <Dice6 {...iconProps} />;
    case "entries": return <List {...iconProps} />;
    case "results": return <Star {...iconProps} />;
    case "logs": return <History {...iconProps} />;
    case "ledger": return <List {...iconProps} />;
    case "rules": return <Settings {...iconProps} />;
    case "reports": return <FileText {...iconProps} />;
    case "categories": return <Tag {...iconProps} />;
    case "groups": return <Tag {...iconProps} />;
    case "sub-types": return <Tag {...iconProps} />;
    case "items": return <Package {...iconProps} />;
    case "variants": return <Package {...iconProps} />;
    case "details": return <FileText {...iconProps} />;
    case "shops": return <Store {...iconProps} />;
    case "points": return <Star {...iconProps} />;
    case "lucky-draw": return <Dice6 {...iconProps} />;
    case "redeem": return <Gift {...iconProps} />;
    case "rewards": return <Star {...iconProps} />;
    default:
      // Fallback based on label content
      if (label.toLowerCase().includes('create') || label.toLowerCase().includes('add')) return <Plus {...iconProps} />;
      if (label.toLowerCase().includes('list') || label.toLowerCase().includes('ledger')) return <List {...iconProps} />;
      if (label.toLowerCase().includes('history') || label.toLowerCase().includes('logs')) return <History {...iconProps} />;
      if (label.toLowerCase().includes('approval') || label.toLowerCase().includes('verification')) return <CheckCircle {...iconProps} />;
      if (label.toLowerCase().includes('download') || label.toLowerCase().includes('print') || label.toLowerCase().includes('report')) return <FileText {...iconProps} />;
      if (label.toLowerCase().includes('payment') || label.toLowerCase().includes('upload')) return <CreditCard {...iconProps} />;
      if (label.toLowerCase().includes('receipt')) return <Receipt {...iconProps} />;
      if (label.toLowerCase().includes('gift') || label.toLowerCase().includes('redeem')) return <Gift {...iconProps} />;
      if (label.toLowerCase().includes('points') || label.toLowerCase().includes('star') || label.toLowerCase().includes('reward')) return <Star {...iconProps} />;
      if (label.toLowerCase().includes('campaign') || label.toLowerCase().includes('draw')) return <Dice6 {...iconProps} />;
      if (label.toLowerCase().includes('user') || label.toLowerCase().includes('people')) return <Users {...iconProps} />;
      if (label.toLowerCase().includes('shop') || label.toLowerCase().includes('store')) return <Store {...iconProps} />;
      if (label.toLowerCase().includes('setting') || label.toLowerCase().includes('config')) return <Settings {...iconProps} />;
      return <List {...iconProps} />; // Default fallback icon
  }
};

export default function TabBar({ tabs, children }: TabBarProps) {
  const pathname = usePathname();
  const router = useRouter();
  
  if (tabs.length === 0) return children || null;

  // Find the active tab based on current pathname
  const activeTab = tabs.find(tab => tab.href === pathname)?.id || tabs[0]?.id || "";
  
  // Handle tab change - navigate to the corresponding URL
  const handleTabChange = (value: string) => {
    const tab = tabs.find(t => t.id === value);
    if (tab) {
      router.push(tab.href);
    }
  };

  // Get the proper grid class based on number of tabs
  const getGridClass = (tabCount: number) => {
    switch (tabCount) {
      case 1: return "grid w-full grid-cols-1";
      case 2: return "grid w-full grid-cols-2";
      case 3: return "grid w-full grid-cols-3";
      case 4: return "grid w-full grid-cols-4";
      case 5: return "grid w-full grid-cols-5";
      case 6: return "grid w-full grid-cols-6";
      default: return "grid w-full grid-cols-5"; // Fallback to 5 columns
    }
  };

  return (
    <Tabs value={activeTab} onValueChange={handleTabChange} className="space-y-6">
      <TabsList className={`${getGridClass(tabs.length)} bg-white border border-gray-200`}>
        {tabs.map((tab) => (
          <TabsTrigger key={tab.id} value={tab.id} className="flex items-center space-x-2 data-[state=active]:bg-white data-[state=active]:border data-[state=active]:border-gray-300 data-[state=active]:shadow-sm">
            {getIconForTab(tab.id, tab.label)}
            <span>{tab.label}</span>
          </TabsTrigger>
        ))}
      </TabsList>
      
      {children && (
        <div className="mt-6">
          {children}
        </div>
      )}
    </Tabs>
  );
}