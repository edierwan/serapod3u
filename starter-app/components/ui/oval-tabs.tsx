import * as React from "react";
export { Tabs, TabsContent } from "@/components/ui/tabs";
import { TabsList, TabsTrigger } from "@/components/ui/tabs";

type Sz = "lg" | "md";
type Layout = "flex" | "grid";

const BASE_LIST = [
  "inline-flex items-center justify-center",
  "rounded-full border border-border/40 bg-gradient-to-b from-white/80 to-white/60 backdrop-blur-md",
  "shadow-[0_2px_12px_rgba(0,0,0,0.08),inset_0_1px_0_rgba(255,255,255,0.6)]",
  "dark:bg-gradient-to-b dark:from-gray-800/80 dark:to-gray-900/60 dark:shadow-[0_2px_12px_rgba(0,0,0,0.3)]",
].join(" ");

const BASE_LIST_GRID = [
  "grid grid-cols-3 w-full",
  "rounded-full border border-border/40 bg-gradient-to-b from-white/80 to-white/60 backdrop-blur-md",
  "shadow-[0_2px_12px_rgba(0,0,0,0.08),inset_0_1px_0_rgba(255,255,255,0.6)]",
  "dark:bg-gradient-to-b dark:from-gray-800/80 dark:to-gray-900/60 dark:shadow-[0_2px_12px_rgba(0,0,0,0.3)]",
].join(" ");

const BASE_TRIG = [
  "inline-flex items-center gap-2.5 whitespace-nowrap",
  "rounded-full font-semibold transition-all duration-300 ease-out",
  "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500/50 focus-visible:ring-offset-2",
  "text-slate-600 hover:text-slate-900 hover:bg-gradient-to-b hover:from-blue-50/80 hover:to-blue-100/60 hover:scale-[0.98]",
  "data-[state=active]:text-white data-[state=active]:bg-gradient-to-b data-[state=active]:from-blue-600 data-[state=active]:to-blue-700",
  "data-[state=active]:ring-2 data-[state=active]:ring-blue-500/30 data-[state=active]:ring-offset-1",
  "data-[state=active]:shadow-[0_4px_16px_rgba(59,130,246,0.3),inset_0_1px_0_rgba(255,255,255,0.2)] data-[state=active]:scale-[0.98]",
  "dark:text-slate-400 dark:hover:text-slate-200 dark:hover:bg-gradient-to-b dark:hover:from-slate-700/60 dark:hover:to-slate-800/40",
  "dark:data-[state=active]:from-blue-500 dark:data-[state=active]:to-blue-600",
].join(" ");

const SIZE = {
  lg: {
    list: "h-12 p-1.5 gap-1",
    trig: "px-7 py-2.5 text-sm",
    icon: "h-4 w-4",
  },
  md: {
    list: "h-11 p-1 gap-1",
    trig: "px-5 py-2 text-[13px]",
    icon: "h-4 w-4",
  },
} as const;

export function OvalTabsList(
  { className = "", size = "lg", layout = "flex", ...props }:
  React.ComponentProps<typeof TabsList> & { size?: Sz; layout?: Layout }
) {
  const baseClasses = layout === "grid" ? BASE_LIST_GRID : BASE_LIST;
  return (
    <TabsList
      {...props}
      className={[
        baseClasses,
        SIZE[size].list,
        "shadow-[inset_0_1px_0_rgba(255,255,255,0.45)] dark:shadow-none",
        className,
      ].join(" ")}
    />
  );
}

export function OvalTab(
  { className = "", size = "lg", children, ...props }:
  React.ComponentProps<typeof TabsTrigger> & { size?: Sz }
) {
  return (
    <TabsTrigger
      {...props}
      className={[BASE_TRIG, SIZE[size].trig, className].join(" ")}
    >
      {children}
    </TabsTrigger>
  );
}

export const pillIcon = (cls: string) => {
  const PillIcon = () =>
    <span className={["shrink-0", cls].join(" ")} aria-hidden="true" />;
  PillIcon.displayName = "PillIcon";
  return PillIcon;
};