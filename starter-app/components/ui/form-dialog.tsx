"use client";

import { useEffect, useRef } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Loader2 } from "lucide-react";

interface FormDialogProps {
  title: string;
  description?: string;
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (e: React.FormEvent) => void;
  submitLabel?: string;
  busy?: boolean;
  disableSubmit?: boolean;
  children: React.ReactNode;
}

export function FormDialog({
  title,
  description,
  isOpen,
  onClose,
  onSubmit,
  submitLabel = "Save",
  busy = false,
  disableSubmit = false,
  children
}: FormDialogProps) {
  const dialogRef = useRef<HTMLDivElement>(null);

  // Handle ESC key
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape" && !busy) {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener("keydown", handleKeyDown);
      return () => document.removeEventListener("keydown", handleKeyDown);
    }
  }, [isOpen, busy, onClose]);

  // Focus trap (simplified - focus first focusable element on open)
  useEffect(() => {
    if (isOpen && dialogRef.current) {
      const focusableElements = dialogRef.current.querySelectorAll(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
      );
      const firstElement = focusableElements[0] as HTMLElement;
      if (firstElement) {
        firstElement.focus();
      }
    }
  }, [isOpen]);

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && !busy && onClose()}>
      <DialogContent
        ref={dialogRef}
        className="w-[680px] max-w-[680px] max-h-[75vh] p-0"
      >
        <div className="flex flex-col max-h-[75vh]">
          {/* Header - Fixed */}
          <DialogHeader className="px-6 pt-6 pb-4 border-b">
            <DialogTitle className="text-2xl font-semibold">{title}</DialogTitle>
            {description && (
              <p className="text-base text-muted-foreground mt-2">
                {description}
              </p>
            )}
          </DialogHeader>

          {/* Body - Scrollable */}
          <div className="flex-1 overflow-y-auto px-6 py-4">
            <form id="form-dialog-form" onSubmit={onSubmit} className="space-y-4">
              {children}
            </form>
          </div>

          {/* Footer - Fixed */}
          <DialogFooter className="px-6 py-4 border-t bg-background">
            <div className="flex justify-end gap-3 w-full">
              <Button
                type="button"
                variant="outline"
                size="lg"
                onClick={onClose}
                disabled={busy}
                className="min-h-[44px]"
              >
                Cancel
              </Button>
              <Button
                type="submit"
                form="form-dialog-form"
                variant="primary"
                size="lg"
                disabled={disableSubmit || busy}
                className="min-h-[44px] min-w-[100px]"
              >
                {busy && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
                {busy ? "Saving..." : submitLabel}
              </Button>
            </div>
          </DialogFooter>
        </div>
      </DialogContent>
    </Dialog>
  );
}