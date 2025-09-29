"use client";

import { useState, useTransition } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AlertTriangle, Shield } from "lucide-react";
import { resetSystemAction } from "./actions";

export function DangerZone() {
  const [showConfirm, setShowConfirm] = useState(false);
  const [confirmationText, setConfirmationText] = useState("");
  const [error, setError] = useState("");
  const [isPending, startTransition] = useTransition();

  const handleReset = () => {
    if (confirmationText !== "RESET") {
      setError("Please type 'RESET' to confirm the system reset.");
      return;
    }

    startTransition(async () => {
      try {
        setError("");
        await resetSystemAction();
        // Reset form on success
        setConfirmationText("");
        setShowConfirm(false);
        alert("System reset completed successfully!");
      } catch (err) {
        setError(err instanceof Error ? err.message : "Reset failed");
      }
    });
  };

  if (!showConfirm) {
    return (
      <div className="rounded-lg border border-red-200 bg-red-50 p-4 dark:border-red-800 dark:bg-red-950">
        <div className="flex items-center gap-3 mb-3">
          <AlertTriangle className="h-5 w-5 text-red-600" />
          <h3 className="font-semibold text-red-900 dark:text-red-100">Complete System Reset</h3>
        </div>
        <p className="text-sm text-red-700 dark:text-red-300 mb-4">
          This action will permanently delete ALL data including master data (manufacturers, products, categories, etc.), transactions, and configurations. This cannot be undone.
        </p>
        <Button
          variant="destructive"
          onClick={() => setShowConfirm(true)}
        >
          Reset System
        </Button>
      </div>
    );
  }

  return (
    <div className="rounded-lg border border-red-200 bg-red-50 p-4 dark:border-red-800 dark:bg-red-950">
      <div className="flex items-center gap-3 mb-4">
        <Shield className="h-5 w-5 text-red-600" />
        <h3 className="font-semibold text-red-900 dark:text-red-100">Confirm System Reset</h3>
      </div>

      <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4 dark:bg-yellow-950 dark:border-yellow-800">
        <div className="flex items-center gap-2">
          <AlertTriangle className="h-4 w-4 text-yellow-600" />
          <p className="text-sm text-yellow-800 dark:text-yellow-200">
            This action will permanently delete ALL data including master data, transactions, and configurations. Type <strong>RESET</strong> below to confirm.
          </p>
        </div>
      </div>

      <div className="space-y-4">
        <div>
          <Label htmlFor="confirmation">Confirmation</Label>
          <Input
            id="confirmation"
            type="text"
            value={confirmationText}
            onChange={(e) => setConfirmationText(e.target.value)}
            placeholder="Type RESET to confirm"
            disabled={isPending}
            className="uppercase"
          />
        </div>

        {error && (
          <div className="bg-red-50 border border-red-200 rounded-lg p-3 dark:bg-red-950 dark:border-red-800">
            <p className="text-sm text-red-800 dark:text-red-200">{error}</p>
          </div>
        )}

        <div className="flex gap-2">
          <Button
            variant="outline"
            onClick={() => {
              setShowConfirm(false);
              setConfirmationText("");
              setError("");
            }}
            disabled={isPending}
          >
            Cancel
          </Button>
          <Button
            variant="destructive"
            onClick={handleReset}
            disabled={isPending || confirmationText !== "RESET"}
          >
            {isPending ? "Resetting..." : "Confirm Reset"}
          </Button>
        </div>
      </div>
    </div>
  );
}