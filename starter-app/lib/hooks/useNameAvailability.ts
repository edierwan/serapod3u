"use client";

import { useState, useEffect, useMemo, useRef } from "react";

// Simple debounce utility
function debounce(func: (name: string) => void, wait: number): (name: string) => void {
  let timeout: NodeJS.Timeout;
  return (name: string) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => func(name), wait);
  };
}

interface UseNameAvailabilityOptions {
  entity: "manufacturers" | "distributors" | "shops";
  excludeId?: string;
  minLength?: number;
}

interface NameAvailabilityResult {
  available: boolean | null;
  error: string | null;
  isChecking: boolean;
}

export function useNameAvailability({
  entity,
  excludeId,
  minLength = 2
}: UseNameAvailabilityOptions): [NameAvailabilityResult, (name: string) => void] {
  const [available, setAvailable] = useState<boolean | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isChecking, setIsChecking] = useState(false);
  const abortControllerRef = useRef<AbortController | null>(null);

  // Cancel any ongoing request when component unmounts or dependencies change
  useEffect(() => {
    return () => {
      if (abortControllerRef.current) {
        abortControllerRef.current.abort();
      }
    };
  }, [entity, excludeId]);

  const checkName = useMemo(
    () => debounce(async (name: string) => {
      // Cancel any previous request
      if (abortControllerRef.current) {
        abortControllerRef.current.abort();
      }

      // Don't check if name is too short
      if (!name.trim() || name.trim().length < minLength) {
        setError(null);
        setAvailable(null);
        setIsChecking(false);
        return;
      }

      setIsChecking(true);
      const controller = new AbortController();
      abortControllerRef.current = controller;

      try {
        const params = new URLSearchParams({
          name: name.trim(),
          ...(excludeId && { excludeId })
        });

        const response = await fetch(`/api/${entity}/check-name?${params}`, {
          signal: controller.signal
        });

        // Check if request was aborted
        if (controller.signal.aborted) {
          return;
        }

        const result = await response.json();

        if (response.status === 409 && result.code === "name_taken") {
          setError(result.message);
          setAvailable(false);
        } else if (response.ok && result.available === true) {
          setError(null);
          setAvailable(true);
        } else {
          // Network or other error
          setError("Couldn't verify name right now. We'll validate on save.");
          setAvailable(null);
        }
      } catch (error) {
        // Check if request was aborted
        if (controller.signal.aborted) {
          return;
        }

        console.error("Error checking name availability:", error);
        setError("Couldn't verify name right now. We'll validate on save.");
        setAvailable(null);
      } finally {
        if (!controller.signal.aborted) {
          setIsChecking(false);
        }
      }
    }, 500),
    [entity, excludeId, minLength]
  );

  return [{ available, error, isChecking }, checkName];
}