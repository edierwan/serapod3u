# AI Design Prompt: Professional Order Interface

## Overview
Create a comprehensive order management interface with a clean, professional design similar to enterprise SaaS applications. The interface should handle product selection, customer information, reward systems, and order calculations with real-time updates.

## Layout Structure

### Main Layout
- **Container**: Full-screen layout with max-width constraint (max-w-7xl)
- **Grid System**: Use a 3-column layout on desktop (xl:grid-cols-3) with 2 columns for main content and 1 for sidebar
- **Responsive**: Stack vertically on mobile, side-by-side on desktop
- **Spacing**: Consistent 6-unit spacing between major sections

### Header Section
- **Title**: Large heading with descriptive subtitle
- **Status Badge**: Right-aligned status indicator (Draft/Pending/Approved)
- **Background**: Clean white/dark mode compatible background

## Component Architecture

### 1. Customer Information Card
**Design Pattern**: Form card with icon header
- **Header**: User icon + "Customer Information" title
- **Layout**: 2-column grid for name/email, full-width for address
- **Fields**: 
  - Customer Name (required, marked with *)
  - Customer Email (optional)
  - Delivery Address (textarea, 3 rows)
  - Order Notes (textarea, 3 rows)
- **Icons**: Use User icon for header, MapPin icon for address label

### 2. Product Selection Card
**Design Pattern**: Dynamic list management with calculations
- **Header**: "Product Selection" title
- **Add Section**: Dropdown select + Add button in horizontal layout
- **Order Lines**: Each line in a nested card with muted background
- **Line Layout**: 4-column grid (Product info, Quantity, Units per case, Actions)
- **Calculations**: Bottom section with 4-column calculation grid showing:
  - Cases count
  - Unique units (with 10% buffer)
  - Line total
  - QR codes breakdown
- **Empty State**: Centered message when no products selected

### 3. Reward Options Card
**Design Pattern**: Toggle-based progressive disclosure
- **Header**: Gift icon + "Rewards & Redemption Options" title
- **Structure**: Two main sections (Rewards, Redemption)
- **Toggle Pattern**: 
  - Switch on right side
  - Label and description on left
  - Conditional content appears in muted background container
- **Reward Types**: Dropdown with icons (Percentage, Fixed Amount, Points)
- **Summary Section**: Blue-tinted background with reward calculations

### 4. Order Summary Card (Sidebar)
**Design Pattern**: Calculation summary with sections
- **Header**: Calculator icon + "Order Summary" title
- **Sections**:
  - Order reference (badge display)
  - Line items breakdown
  - QR Code generation summary (with QrCode icon)
  - Financial summary with separators
  - Export information (with Package icon)
- **Visual Hierarchy**: Use separators between sections
- **Color Coding**: Green for discounts, blue for rewards

### 5. Order Actions Card (Sidebar)
**Design Pattern**: Vertical action stack
- **Buttons**: Full-width, stacked vertically with consistent spacing
- **Icons**: Save, Send, FileText icons for different actions
- **States**: Disabled states based on form validation
- **Info Text**: Small helper text at bottom with bullet points

## Design System

### Colors & Theming
- **Primary**: Clean blacks/whites with good contrast
- **Muted Backgrounds**: Light gray backgrounds for nested content (bg-muted/30)
- **Accent Colors**: 
  - Green for positive values (redemptions, success)
  - Blue for rewards and info
  - Red for errors and destructive actions
- **Status Colors**: 
  - Gray for drafts
  - Orange for pending
  - Green for approved

### Typography
- **Headers**: Medium font weight, appropriate sizing hierarchy
- **Labels**: Medium weight for form labels
- **Body Text**: Normal weight for descriptions and content
- **Small Text**: Muted foreground color for helper text

### Spacing & Layout
- **Card Padding**: Consistent padding using CardContent
- **Form Spacing**: 4-unit spacing between form elements
- **Section Spacing**: 6-unit spacing between major sections
- **Grid Gaps**: 4-unit gaps in grid layouts

### Interactive Elements
- **Buttons**: Use shadcn/ui Button component with proper variants
- **Form Fields**: Consistent Input, Select, Textarea components
- **Switches**: Toggle switches for enable/disable options
- **Badges**: Status indicators and small info displays

## Functional Requirements

### State Management
- Customer information (name, email, address, notes)
- Dynamic order lines array with product, quantity, units per case
- Reward settings (enabled, type, value)
- Redemption settings (enabled, amount)
- Order status (draft, pending, approved)

### Calculations
- **Per Line**: Cases = ceil(quantity / unitsPerCase)
- **Unique Units**: ceil(quantity * 1.1) for 10% buffer
- **Line Total**: quantity * product.basePrice
- **QR Codes**: Master QRs = cases, Unique QRs = unique units
- **Rewards**: Percentage or fixed amount calculations
- **Final Total**: Subtotal minus redemptions

### Validation & Feedback
- **Required Fields**: Customer name validation
- **Button States**: Disable when invalid or incomplete
- **Toast Notifications**: Success/error feedback for actions
- **Progressive Disclosure**: Show/hide sections based on toggles

## Technical Implementation

### Components Structure
```
OrderInterface (main container)
├── CustomerInformation (form card)
├── ProductSelector (dynamic list management)
├── RewardOptions (toggle-based configuration)
├── OrderSummary (calculation display)
└── OrderActions (action buttons)
```

### Key Features
- **Real-time Calculations**: Update totals as quantities change
- **Dynamic Product Management**: Add/remove products from order
- **Conditional Rendering**: Show/hide sections based on settings
- **Responsive Design**: Mobile-first with desktop enhancements
- **Accessibility**: Proper labels, IDs, and ARIA attributes

## Visual Polish

### Icons
- Use lucide-react icons consistently
- Match icons to content context (User, Gift, Calculator, etc.)
- Size icons appropriately (h-4 w-4 for inline, h-5 w-5 for headers)

### Loading States
- Consider skeleton loading for dynamic content
- Disabled states for buttons during processing

### Error Handling
- Form validation with clear error messages
- Graceful handling of edge cases
- User-friendly error notifications

This prompt should guide any AI to create a similar professional order interface with the same design patterns, component structure, and user experience as the reference implementation.