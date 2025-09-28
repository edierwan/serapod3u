# Button System Guide

## Overview
This project uses a single, reliable button system to ensure primary CTAs are always visible and readable in all states (enabled/disabled).

## Core Components

### Button Component (`components/ui/button.tsx`)
- **Default variant**: `primary` (solid brand color)
- **Disabled behavior**: Maintains same bg + text colors, reduces opacity to 0.6
- **Never use**: Raw `<button>` elements or custom inline styles

### EmptyState Component (`components/ui/empty-state.tsx`)
- Always uses `variant="primary"` for primary CTAs
- Handles loading/disabled states correctly
- Use for all empty state scenarios

## Usage Guidelines

### Primary Actions (Create/Save CTAs)
```tsx
// ✅ Correct
<Button variant="primary">Create Product</Button>
<Button variant="primary" disabled={isLoading}>Saving...</Button>

// ❌ Wrong
<button className="bg-blue-600 text-white">Create Product</button>
<Button variant="ghost">Create Product</Button>
```

### Secondary Actions (Cancel/Back)
```tsx
// ✅ Correct
<Button variant="outline">Cancel</Button>

// ❌ Wrong
<Button variant="secondary">Cancel</Button>
```

### Empty States
```tsx
// ✅ Correct
<EmptyState
  icon={Box}
  title="No products found"
  body="Get started by creating your first product."
  primaryCta={{
    label: "Create Product",
    onClick: handleCreate
  }}
/>

// ❌ Wrong
<div className="text-center py-12">
  <p>No products found</p>
  <button className="bg-blue-600 text-white">Create Product</button>
</div>
```

## Migration Notes

### From Custom Styles
Replace custom button classes with the shared Button component:

```tsx
// Old
<Link className="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-blue-600 border border-transparent rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
  Add Brand
</Link>

// New
<Button asChild variant="primary">
  <Link href="/brands/create">Add Brand</Link>
</Button>
```

### From Raw Buttons
Replace raw `<button>` elements:

```tsx
// Old
<button type="submit" className="bg-blue-600 text-white px-4 py-2 rounded">
  Save
</button>

// New
<Button type="submit" variant="primary">
  Save
</Button>
```

## Testing
Run CTA visibility tests:
```bash
npm run test
```

Tests verify:
- Primary CTAs are visible (opacity ≥ 0.6)
- Contrast ratio meets WCAG AA standards
- Disabled states maintain readability

## ESLint Rules
The following patterns are forbidden:
- `opacity-0`, `text-transparent`, `bg-transparent` on primary buttons
- Raw `<button>` elements without Button component
- Custom styled Link elements instead of Button + asChild

## Design Tokens
- `--primary`: Brand blue (#2563eb)
- `--primary-foreground`: White text
- Disabled: Same colors with `opacity: 0.6`

## Dark Mode
All button variants maintain proper contrast in dark mode.