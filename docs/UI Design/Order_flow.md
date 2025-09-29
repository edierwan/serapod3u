# Complete Order Management System - AI Development Prompt

## Project Overview
Build a comprehensive B2B Order Management System with workflow tracking that handles the complete order lifecycle from creation to manufacturing and distribution. The system should provide a professional interface similar to food delivery tracking but for manufacturing orders, with role-based access, real-time calculations, and document management.

## Core Functionality Requirements

### 1. Order Creation Interface
**Component: OrderInterface**
- **Product Selection**: Grid-based product selector with quantity inputs
- **Unit Selection**: Toggle between 100 and 200 units per case
- **Real-time Calculations**: 
  - Cases = Quantity ÷ Units per case (rounded up)
  - Master QR codes = Cases
  - Unique QR codes = Cases × Units per case × 1.1 (10% buffer, rounded up)
- **Financial Calculations**: Subtotal, taxes, discounts, final total
- **Customer Information**: Name, contact, delivery address fields
- **Order Notes**: Text area for special instructions
- **Lucky Draw & Redeem Options**: Configurable reward system

### 2. Product Data Structure
```javascript
const products = [
  {
    id: '1',
    name: 'Premium Wireless Headphones',
    description: 'High-quality wireless headphones with noise cancellation',
    price: 89.99,
    image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
    category: 'Electronics'
  }
  // Add 6-8 more products with realistic data
];
```

### 3. Lucky Draw & Redeem System
**Component: RewardOptions**
- **Lucky Draw Section**:
  - Toggle to enable/disable
  - Prize types: Percentage Cashback, Fixed Prize Amount, Loyalty Points
  - Value input with validation
  - Preview of prize calculation
- **Redeem Section**:
  - Toggle to allow redemption
  - Amount input for redemption value
  - Real-time deduction from order total
- **Summary Display**: Shows both lucky draw prize and redemption amount

### 4. Order Summary Sidebar
**Component: OrderSummary**
- **Product List**: Selected products with quantities and totals
- **Calculations Display**:
  - Cases calculation with units per case
  - QR codes (Master and Unique with 10% buffer)
  - Subtotal, tax, discount calculations
  - Lucky draw prize display
  - Redemption deduction
  - Final total
- **Order Status**: Draft → Pending → Approved workflow
- **Action Buttons**: Save Draft, Submit for Approval, etc.

### 5. Workflow Tracking System
**Component: WorkflowTracker**
- **Timeline Visualization**: Step-by-step progress similar to food delivery tracking
- **Role-based Actors**: HQ Admin, Power User, Manufacturer, Distributor, Shop
- **Status Types**: completed, active, pending, blocked
- **Document Tracking**: PO, invoices, payments, receipts
- **Actor Avatars**: Color-coded by role with appropriate icons

### 6. Order Dashboard
**Component: OrderDashboard**
- **Statistics Cards**: Total orders, pending, manufacturing, completed, total value
- **Order List**: Filterable and searchable order grid
- **Status Management**: Visual status badges and priority indicators
- **Navigation**: Switch between dashboard, create order, and track order views

## Detailed Workflow Steps

### Order Lifecycle (10+ Steps):
1. **Order Created** (HQ Admin) - Order details generated
2. **Awaiting Power User Approval** (Power User) - Review and approve
3. **PO Generation** (System) - Auto-generate purchase order
4. **Manufacturer Acknowledgment** (Manufacturer) - Confirm receipt
5. **Invoice Generation** (System) - Create manufacturing invoice
6. **Invoice Review** (Manufacturer) - Review and submit
7. **Payment Processing** (Power User) - Process payment
8. **Payment Acknowledgment** (Manufacturer) - Confirm receipt
9. **Receipt Generation** (System) - Generate payment receipt
10. **Production & QR Generation** (Manufacturer) - Begin production

## Design System Specifications

### Color Scheme & Styling
- **Primary Colors**: Professional blue/purple gradient
- **Status Colors**: 
  - Completed: Green (#22c55e)
  - Active: Blue (#3b82f6)
  - Pending: Gray (#6b7280)
  - Blocked: Red (#ef4444)
- **Role Colors**:
  - HQ Admin: Blue (#3b82f6)
  - Power User: Purple (#8b5cf6)
  - Manufacturer: Orange (#f97316)
  - Distributor: Green (#22c55e)
  - Shop: Pink (#ec4899)

### Component Library
Use shadcn/ui components exclusively:
- Cards for layout sections
- Badges for status indicators
- Buttons with proper variants
- Forms with validation
- Tabs for navigation
- Avatars for user representation
- Select dropdowns for options
- Switch toggles for boolean options

### Icons (Lucide React)
- Package, Truck, Store, Building2, Factory for actors
- CheckCircle, Clock, AlertTriangle for status
- Plus, Search, Filter, Eye, Download for actions
- Gift, Percent, DollarSign, Sparkles for rewards

## Technical Implementation

### State Management
```javascript
// Order state structure
const [orderData, setOrderData] = useState({
  products: [],
  customerInfo: {},
  deliveryAddress: {},
  orderNotes: '',
  status: 'draft',
  luckyDraw: { enabled: false, type: '', value: 0 },
  redeem: { enabled: false, amount: 0 },
  unitsPerCase: 100
});
```

### Calculation Functions
```javascript
// Cases calculation
const calculateCases = (quantity, unitsPerCase) => Math.ceil(quantity / unitsPerCase);

// QR codes calculation
const calculateQRCodes = (cases, unitsPerCase) => ({
  master: cases,
  unique: Math.ceil(cases * unitsPerCase * 1.1) // 10% buffer
});

// Financial calculations
const calculateTotals = (products, luckyDraw, redeem) => {
  const subtotal = products.reduce((sum, p) => sum + (p.price * p.quantity), 0);
  const tax = subtotal * 0.1; // 10% tax
  const luckyDrawAmount = luckyDraw.type === 'percentage' ? 
    subtotal * (luckyDraw.value / 100) : luckyDraw.value;
  const total = subtotal + tax - redeem.amount;
  return { subtotal, tax, luckyDrawAmount, total };
};
```

### Component Architecture
```
App.tsx
├── OrderDashboard.tsx (Main container)
    ├── OrderInterface.tsx (Order creation)
    │   ├── ProductSelector.tsx
    │   ├── RewardOptions.tsx
    │   └── OrderSummary.tsx
    └── WorkflowTracker.tsx (Order tracking)
```

## User Experience Requirements

### Responsive Design
- Mobile-first approach with responsive grid layouts
- Collapsible sidebar on mobile devices
- Touch-friendly buttons and inputs
- Optimized typography scaling

### Interaction Patterns
- **Real-time Updates**: All calculations update immediately on input change
- **Form Validation**: Proper error states and validation messages
- **Loading States**: Skeleton loaders and progress indicators
- **Confirmation Dialogs**: For critical actions like order submission
- **Toast Notifications**: Success/error feedback using Sonner

### Accessibility
- Proper ARIA labels and semantic HTML
- Keyboard navigation support
- Screen reader compatibility
- High contrast color ratios
- Focus management

## Business Logic Rules

### Order Validation
- Minimum 1 product required
- Customer information must be complete
- Valid delivery address required
- Lucky draw value cannot exceed order total
- Redeem amount cannot exceed available balance

### Workflow Rules
- Only Power Users can approve orders
- Manufacturers can only act on approved orders
- Payment must be confirmed before production begins
- Documents are auto-generated at specific workflow steps

### Role Permissions
- **HQ Admin**: Create orders, view all orders, manage customers
- **Power User**: Approve orders, process payments, view financials
- **Manufacturer**: Acknowledge orders, submit invoices, confirm production
- **Distributor**: Receive orders, manage inventory, coordinate delivery
- **Shop**: View order status, provide feedback

## Data Structures

### Order Object
```javascript
{
  id: string,
  reference: string, // ORD-2024-001 format
  customerName: string,
  status: 'draft' | 'pending_approval' | 'approved' | 'manufacturing' | 'completed',
  products: [{ id, name, price, quantity, total }],
  totals: { subtotal, tax, discount, final },
  qrCodes: { master, unique },
  cases: number,
  luckyDraw: { enabled, type, value, amount },
  redeem: { enabled, amount },
  createdAt: timestamp,
  createdBy: string,
  workflow: [{ step, status, timestamp, actor, documents }]
}
```

## Mock Data Requirements

### Sample Products (8-10 items)
Include electronics, accessories, and gadgets with realistic pricing and high-quality Unsplash images.

### Sample Orders (4-6 orders)
Different statuses, various totals, different creation dates, multiple user roles.

### Sample Customers
Realistic B2B customer names, addresses, and contact information.

## Styling Guidelines

### Layout
- **Container**: Max width with centered content
- **Spacing**: Consistent 4px grid system
- **Cards**: Rounded corners with subtle shadows
- **Grid**: Responsive 1-4 column layouts

### Typography
- **Headings**: Medium weight, proper hierarchy
- **Body Text**: Regular weight, readable line height
- **Labels**: Medium weight for form labels
- **Captions**: Smaller, muted color for secondary info

### Interactive Elements
- **Buttons**: Clear hierarchy (primary, secondary, outline)
- **Forms**: Clean inputs with proper focus states
- **Status Badges**: Color-coded with appropriate text
- **Progress Indicators**: Clear visual progress

## Quality Assurance

### Testing Scenarios
1. Create order with multiple products
2. Test calculation accuracy with different unit selections
3. Verify lucky draw calculations
4. Test redemption amount validation
5. Navigate through complete workflow
6. Test role-based permissions
7. Verify responsive design on mobile
8. Test form validation and error handling

### Performance Considerations
- Optimize image loading with proper lazy loading
- Debounce calculation updates
- Efficient state management
- Minimal re-renders on updates

### Error Handling
- Graceful fallbacks for failed calculations
- Clear error messages for validation
- Retry mechanisms for failed operations
- Proper loading and error states

## Final Implementation Notes

1. **Start with OrderInterface**: Build the core order creation functionality first
2. **Add WorkflowTracker**: Implement the timeline visualization system
3. **Build OrderDashboard**: Create the management interface
4. **Integrate Components**: Connect all pieces with proper state management
5. **Polish UX**: Add animations, loading states, and error handling
6. **Test Thoroughly**: Verify all calculations and workflow logic

The final application should feel like a professional B2B order management system with the user experience quality of modern consumer applications like food delivery tracking, but tailored for manufacturing and distribution workflows.