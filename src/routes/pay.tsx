import { createFileRoute } from "@tanstack/react-router";
import { ManualPaymentDialog } from "@/components/manual-payment-dialog";
import { useStore } from "@/lib/store";

export const Route = createFileRoute("/pay")({
  component: PayComponent,
});

function PayComponent() {
  const { settings } = useStore();
  return (
    <div className="min-h-screen bg-background p-4 flex flex-col items-center justify-center">
      <h1 className="text-2xl font-bold mb-4">{settings.brandName || "دفع الاشتراك"}</h1>
      <ManualPaymentDialog open={true} onOpenChange={() => {}} />
    </div>
  );
}
