# Tab Navigation Design Prompt for AI Coders

## Overview
This prompt provides the exact specifications for implementing tab navigation that matches the professional design pattern used in our rewards system. Follow these guidelines precisely to maintain consistency across the application.

## Required Dependencies
```typescript
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./components/ui/tabs";
import { Plus, Gift, History } from "lucide-react"; // Or other Lucide React icons
```

## Core Tab Structure Pattern

### 1. Main Tabs Container
```typescript
<Tabs defaultValue="earn" className="space-y-6">
  {/* TabsList and TabsContent components go here */}
</Tabs>
```

**Key Requirements:**
- Always use `space-y-6` for consistent vertical spacing
- Set appropriate `defaultValue` to match your first tab
- Wrap all tab-related content within this container

### 2. Tab Navigation List
```typescript
<TabsList className="grid w-full grid-cols-3">
  {/* Individual TabsTrigger components */}
</TabsList>
```

**Key Requirements:**
- Use `grid w-full` for full-width layout
- Adjust `grid-cols-{n}` based on number of tabs (e.g., `grid-cols-3` for 3 tabs, `grid-cols-4` for 4 tabs)
- This creates equal-width tabs that span the full container width

### 3. Individual Tab Triggers
```typescript
<TabsTrigger value="earn" className="flex items-center space-x-2">
  <Plus className="h-4 w-4" />
  <span>Earn Points</span>
</TabsTrigger>
```

**Key Requirements:**
- Always use `flex items-center space-x-2` for icon + text layout
- Icons should be `h-4 w-4` size for consistency
- Wrap text content in `<span>` tags
- Use semantic `value` attributes that match your content sections

### 4. Tab Content Sections
```typescript
<TabsContent value="earn">
  {/* Your tab content component */}
</TabsContent>
```

**Key Requirements:**
- Each `TabsContent` value must match its corresponding `TabsTrigger` value
- Content should be wrapped in appropriate components or containers

## Complete Example Implementation

```typescript
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./components/ui/tabs";
import { Plus, Gift, History, Star, Settings } from "lucide-react";

export function MyTabComponent() {
  return (
    <Tabs defaultValue="tab1" className="space-y-6">
      <TabsList className="grid w-full grid-cols-5">
        <TabsTrigger value="tab1" className="flex items-center space-x-2">
          <Plus className="h-4 w-4" />
          <span>Tab One</span>
        </TabsTrigger>
        <TabsTrigger value="tab2" className="flex items-center space-x-2">
          <Gift className="h-4 w-4" />
          <span>Tab Two</span>
        </TabsTrigger>
        <TabsTrigger value="tab3" className="flex items-center space-x-2">
          <History className="h-4 w-4" />
          <span>Tab Three</span>
        </TabsTrigger>
        <TabsTrigger value="tab4" className="flex items-center space-x-2">
          <Star className="h-4 w-4" />
          <span>Tab Four</span>
        </TabsTrigger>
        <TabsTrigger value="tab5" className="flex items-center space-x-2">
          <Settings className="h-4 w-4" />
          <span>Tab Five</span>
        </TabsTrigger>
      </TabsList>

      <TabsContent value="tab1">
        {/* Your tab 1 content */}
      </TabsContent>

      <TabsContent value="tab2">
        {/* Your tab 2 content */}
      </TabsContent>

      <TabsContent value="tab3">
        {/* Your tab 3 content */}
      </TabsContent>

      <TabsContent value="tab4">
        {/* Your tab 4 content */}
      </TabsContent>

      <TabsContent value="tab5">
        {/* Your tab 5 content */}
      </TabsContent>
    </Tabs>
  );
}
```

## Icon Selection Guidelines

### Recommended Lucide React Icons for Common Tab Types:
- **Earn/Add/Create**: `Plus`, `PlusCircle`, `Trophy`
- **Rewards/Benefits**: `Gift`, `Star`, `Award`
- **History/Logs**: `History`, `Clock`, `List`
- **Profile/Account**: `User`, `Settings`, `UserCircle`
- **Analytics/Stats**: `BarChart3`, `TrendingUp`, `Activity`
- **Search/Explore**: `Search`, `Compass`, `Telescope`
- **Messages/Chat**: `MessageCircle`, `Mail`, `Bell`
- **Settings/Config**: `Settings`, `Cog`, `Sliders`

## Design System Integration

### Color Scheme
The tabs automatically inherit the design system colors:
- **Active tabs**: Use `--primary` color with `--primary-foreground` text
- **Inactive tabs**: Use `--muted` background with `--muted-foreground` text
- **Hover states**: Subtle transitions using `--accent` colors

### Typography
- Tab text uses the default typography system (no manual font classes needed)
- Icons and text are perfectly aligned using the flex layout pattern

### Spacing
- `space-y-6`: Consistent vertical spacing between tab navigation and content
- `space-x-2`: Optimal spacing between icons and text within tabs
- `h-4 w-4`: Standard icon size for tab navigation

## Responsive Behavior

The tab design is automatically responsive:
- **Desktop**: Full-width tabs with icons and text
- **Mobile**: Tabs may stack or scroll horizontally (handled by shadcn/ui)
- **Touch targets**: Adequate size for mobile interaction

## Common Patterns

### 3-Tab Layout (Most Common)
```typescript
<TabsList className="grid w-full grid-cols-3">
  {/* 3 tabs */}
</TabsList>
```

### 4-Tab Layout
```typescript
<TabsList className="grid w-full grid-cols-4">
  {/* 4 tabs */}
</TabsList>
```

### 5+ Tab Layout
```typescript
<TabsList className="grid w-full grid-cols-5">
  {/* 5 tabs */}
</TabsList>
```

## DO NOT Modify
- Never change the icon size from `h-4 w-4`
- Never modify the `flex items-center space-x-2` layout pattern
- Never add custom font size, weight, or line-height classes (let the design system handle typography)
- Never use custom colors (rely on the CSS custom properties)

## Implementation Checklist
- [ ] Import shadcn/ui Tabs components
- [ ] Import appropriate Lucide React icons
- [ ] Use `space-y-6` on main Tabs container
- [ ] Use `grid w-full grid-cols-{n}` on TabsList
- [ ] Use `flex items-center space-x-2` on each TabsTrigger
- [ ] Icons are `h-4 w-4` size
- [ ] Text is wrapped in `<span>` tags
- [ ] All values between TabsTrigger and TabsContent match
- [ ] Set appropriate defaultValue

This pattern ensures consistent, professional-looking tabs that integrate seamlessly with the existing design system.