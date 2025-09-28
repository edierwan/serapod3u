"use client";

import { useTransition } from "react";
import { Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { deleteCategory } from "./actions";
import { toast } from "sonner";
import { useRouter } from "next/navigation";

interface DeleteCategoryButtonProps {
  categoryId: string;
  categoryName: string;
}

export default function DeleteCategoryButton({ categoryId, categoryName }: DeleteCategoryButtonProps) {
  const [isPending, startTransition] = useTransition();
  const router = useRouter();

  const handleDelete = () => {
    if (!confirm(`Are you sure you want to delete the category "${categoryName}"? This action cannot be undone.`)) {
      return;
    }

    startTransition(async () => {
      const result = await deleteCategory(categoryId);
      
      if (result.ok) {
        toast.success("Category deleted successfully");
        router.refresh();
      } else {
        toast.error(result.message);
      }
    });
  };

  return (
    <Button
      onClick={handleDelete}
      disabled={isPending}
      variant="destructive"
      size="sm"
    >
      <Trash2 className="h-4 w-4" />
      {isPending ? "Deleting..." : "Delete"}
    </Button>
  );
}