# UI_CONTRACT.md

## Sidebar (2‑Level, Final)
- 🏠 Dashboard
- 📂 Order Management
  - Orders (Create | Approval | List)
  - Purchase Orders (PO List | Acknowledge)
  - Invoices (Invoice List | Download/Print)
  - Payments (Upload Proof | Verification | History)
  - Receipts (Receipt List | Download/Print)
- 📍 Tracking
  - Case Movements (Inbound | Outbound)
  - Scan History (By Batch | By Case)
  - Blocked/Returned (Blocked | Returned)
- 🎯 Campaigns & Rewards
  - 🎲 Lucky Draw (Campaigns | Entries | Results)
  - 🎁 Redeem (Campaigns | Redemption Logs)
  - ⭐ Rewards (Points) (Ledger | Rules | Reports)
- ⚙️ Master Data
  - Products (Categories | Groups | Sub‑Types | Items)
  - Manufacturers (List | Details)
- ⚙️ Settings
  - Danger Zone (disabled placeholder)
  - Sign Out (lucide `LogOut` icon)

### UI Rules
- Sidebar items filtered by role.
- Each leaf page renders SSR; no client secrets. 
