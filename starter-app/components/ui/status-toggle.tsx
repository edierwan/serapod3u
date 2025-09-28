"use client";

import * as React from "react";
import { cn } from "@/lib/utils";

export interface StatusToggleProps extends Omit<React.InputHTMLAttributes<HTMLInputElement>, "type"> {
  onCheckedChange?: (checked: boolean) => void;
  disabled?: boolean;
  loading?: boolean;
}

const StatusToggle = React.forwardRef<HTMLInputElement, StatusToggleProps>(
  ({ className, onCheckedChange, disabled = false, loading = false, defaultChecked, ...props }, ref) => {
    const isChecked = props.checked ?? defaultChecked ?? false;
    const isDisabled = disabled || loading;

    return (
      <div className="flex items-center space-x-3">
        <label className="inline-flex items-center cursor-pointer">
          <input
            type="checkbox"
            className="sr-only"
            ref={ref}
            checked={isChecked}
            onChange={(e) => !isDisabled && onCheckedChange?.(e.target.checked)}
            disabled={isDisabled}
            aria-checked={isChecked}
            aria-labelledby={`status-toggle-label-${props.id || 'default'}`}
            {...props}
          />
          <div
            className={cn(
              "relative inline-flex h-6 w-11 items-center rounded-full transition-colors duration-200",
              // Active (ON): Green track
              isChecked && !isDisabled && "bg-green-500",
              // Inactive (OFF): Amber track
              !isChecked && !isDisabled && "bg-amber-400",
              // Disabled: Reduced opacity
              isDisabled && "opacity-60",
              // Focus ring
              "focus-within:ring-2 focus-within:ring-blue-500 focus-within:ring-offset-2",
              className
            )}
          >
            <span
              className={cn(
                "inline-block h-4 w-4 transform rounded-full bg-white shadow-sm transition-transform duration-200",
                isChecked ? "translate-x-6" : "translate-x-1"
              )}
            />
          </div>
        </label>
        <span
          id={`status-toggle-label-${props.id || 'default'}`}
          className={cn(
            "text-sm font-medium select-none",
            // Active: Dark text for contrast
            isChecked && "text-gray-900",
            // Inactive: Dark amber/neutral text
            !isChecked && "text-amber-800",
            // Disabled: Maintain readability
            isDisabled && "opacity-75"
          )}
        >
          {isChecked ? "Active" : "Inactive"}
        </span>
      </div>
    );
  }
);

StatusToggle.displayName = "StatusToggle";

export { StatusToggle };