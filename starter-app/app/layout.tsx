
import "./globals.css";
import type { ReactNode } from "react";
import { Toaster } from "sonner";

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body className="bg-white">
        {children}
        <Toaster richColors position="top-right" />
      </body>
    </html>
  );
}
