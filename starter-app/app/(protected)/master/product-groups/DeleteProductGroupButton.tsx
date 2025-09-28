"use client";

import { useTransition } from "react";
import { Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { deleteProductGroup } from "./actions";
import { toast } from "sonner";
import { useRouter } from "next/navigation";

interface DeleteProductGroupButtonProps {
  groupId: string;
  groupName: string;
}

export default function DeleteProductGroupButton({ groupId, groupName }: DeleteProductGroupButtonProps) {
  const [isPending, startTransition] = useTransition();
  const router = useRouter();

  const handleDelete = () => {
    if (!confirm(`Are you sure you want to delete the product group "${groupName}"? This action cannot be undone.`)) {
      return;
    }

    startTransition(async () => {
      const result = await deleteProductGroup(groupId);
      
      if (result.ok) {
        toast.success("Product group deleted successfully");
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