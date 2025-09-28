"use client";

import { Button } from "@/components/ui/button";
import { LucideIcon } from "lucide-react";

interface EmptyStateProps {
  icon: LucideIcon;
  title: string;
  body: string;
  primaryCta?: {
    label: string;
    onClick?: () => void;
    href?: string;
    disabled?: boolean;
    loading?: boolean;
  };
  secondaryCta?: {
    label: string;
    onClick?: () => void;
    href?: string;
    disabled?: boolean;
  };
}

export function EmptyState({
  icon: Icon,
  title,
  body,
  primaryCta,
  secondaryCta
}: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center py-12 text-center">
      <Icon className="w-12 h-12 text-gray-400 mb-4" />
      <h3 className="text-lg font-medium text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-500 mb-6 max-w-md">{body}</p>
      <div className="flex flex-col sm:flex-row gap-3">
        {primaryCta && (
          primaryCta.href ? (
            <Button variant="primary" size="lg" asChild>
              <a href={primaryCta.href}>{primaryCta.label}</a>
            </Button>
          ) : (
            <Button
              onClick={primaryCta.onClick}
              disabled={primaryCta.disabled || primaryCta.loading}
              variant="primary"
              size="lg"
            >
              {primaryCta.loading && (
                <div className="w-4 h-4 mr-2 border-2 border-white border-t-transparent rounded-full animate-spin" />
              )}
              {primaryCta.label}
            </Button>
          )
        )}
        {secondaryCta && (
          secondaryCta.href ? (
            <Button variant="secondary" asChild>
              <a href={secondaryCta.href}>{secondaryCta.label}</a>
            </Button>
          ) : (
            <Button
              variant="secondary"
              onClick={secondaryCta.onClick}
              disabled={secondaryCta.disabled}
            >
              {secondaryCta.label}
            </Button>
          )
        )}
      </div>
    </div>
  );
}