
"use client";
import Link from "next/link";

export default function Sidebar({ items }: { items: {label:string; href:string}[] }) {
  return (
    <aside className="w-64 border-r border-border h-full p-3 space-y-1">
      {items.map((i) => (
        <Link key={i.href} href={i.href} className="block rounded-lg px-3 py-2 hover:bg-muted">
          {i.label}
        </Link>
      ))}
    </aside>
  );
}
