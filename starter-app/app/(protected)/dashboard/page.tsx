
export default function DashboardPage() {
  return (
    <div className="space-y-4 bg-white">
      <h1 className="text-xl font-semibold">Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {["Pending Approvals", "POs Awaiting Ack", "Unpaid Invoices", "Activations Today"].map((t) => (
          <div key={t} className="rounded-xl border border-border bg-white p-4 shadow-sm">
            <div className="text-sm text-muted-foreground">{t}</div>
            <div className="text-2xl font-semibold mt-2">0</div>
          </div>
        ))}
      </div>
    </div>
  );
}
