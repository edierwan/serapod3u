# UI Design Guidelines for Distributor-Manufacturer-Shop Management System

## System Overview
Create a comprehensive business management system that handles the three-way relationship between manufacturers, distributors, and shops. This system should provide role-based dashboards with distinct views for each user type, featuring modern UI components, real-time statistics, and comprehensive business management tools.

## Core Architecture Requirements

### 1. Role-Based Authentication System
- Implement user role switching with three primary roles: `manufacturer`, `distributor`, `shop`
- Create a professional login/role selection interface with clear role indicators
- Each role should have distinct dashboard views and permissions
- Include user profile display with role badges in the top navigation

### 2. Entity Relationships
- **Manufacturers**: Can authorize multiple distributors, track distributor performance
- **Distributors**: Connected to manufacturers and authorized for specific shops
- **Shops**: Can work with multiple distributors, each connected to different manufacturers
- Create many-to-many relationships between all three entities

### 3. Dashboard Components Structure

#### Manufacturer Dashboard Features:
- Overview of all authorized distributors
- Statistics: Total distributors, active distributors, total shops reached
- Distributor performance metrics and regional coverage
- Search and filter distributors by region, status, shop count

#### Distributor Dashboard Features:
- Connected manufacturers and authorized shops view
- Statistics: Manufacturer partnerships, authorized shops, active relationships  
- Shop management with status tracking
- Regional coverage and performance metrics

#### Shop Dashboard Features:
- View of connected distributors and their manufacturers
- Supply chain visibility showing manufacturer → distributor → shop relationships
- Order history, distributor ratings, contact management
- Statistics on distributor relationships and supply sources

## UI/UX Design Requirements

### 1. Component Library Usage
Use shadcn/ui components consistently throughout:
- **Cards**: For entity displays (ManufacturerCard, DistributorCard, ShopCard)
- **Badges**: For status indicators (active/inactive/pending)
- **Tables**: For detailed data views and management
- **Statistics Cards**: For key metrics and KPIs
- **Search/Filter**: Input fields with icons and select dropdowns
- **Navigation**: Clean header with role switching and user info

### 2. Layout Patterns
- **Grid Layouts**: Responsive 1-3 column grids for entity cards
- **Statistics Row**: 3-4 metric cards at the top of each dasho
- **Header Section**: Entity name, location/region, and status badge
- **Search Bar**: Full-width search with icon and filter dropdowns
- **Action Buttons**: "View Details", "Edit", "Contact" options on cards

### 3. Visual Design Principles
- Professional, clean aesthetic using the existing color scheme
- Consistent spacing and typography from globals.css
- Clear visual hierarchy with proper headings (h1, h2, h3)
- Status-based color coding (green for active, orange for inactive, etc.)
- Icons from lucide-react for visual consistency

## Technical Implementation Guidelines

### 1. File Structure
```
/components
  /ManufacturerDashboard.tsx
  /DistributorDashboard.tsx (enhanced)
  /ShopDashboard.tsx (enhanced)
  /ManufacturerCard.tsx
  /DistributorCard.tsx (existing)
  /ShopCard.tsx (existing)
  /ui/ (existing shadcn components)
/data
  /mockData.ts (expanded for three entities)
/types
  /index.ts (updated type definitions)
```

### 2. Data Structure Requirements
Create comprehensive mock data including:
- Manufacturers with authorized distributor lists
- Enhanced distributors with manufacturer and shop connections
- Shops with distributor and indirect manufacturer relationships
- Realistic business information (names, addresses, contact info, regions)
- Relationship mapping with IDs for many-to-many connections

### 3. Component Props and State
- Each dashboard component receives entity ID as prop
- Implement local state for search, filtering, and view modes
- Create reusable card components with consistent prop interfaces
- Use proper TypeScript interfaces for all data structures

## Feature Requirements

### 1. Search and Filtering
- Real-time search across entity names, regions, and contact information
- Status filtering (active, inactive, pending)
- Region-based filtering for geographical management
- Sort options (alphabetical, date added, status)

### 2. Statistics and Analytics
- Entity counts and status breakdowns
- Relationship metrics (distributors per manufacturer, shops per distributor)
- Performance indicators and growth metrics
- Visual representation with appropriate icons

### 3. Interactive Elements
- Click-to-view details functionality
- Contact information display and interaction
- Status change capabilities
- Relationship management tools

## Styling and Theme Guidelines

### 1. Color Usage
- Maintain existing CSS custom properties and color scheme
- Use semantic colors: green for active, orange for warnings, red for inactive
- Consistent badge colors based on status
- Professional neutral background colors

### 2. Typography
- Follow existing typography hierarchy from globals.css
- Use consistent font weights (medium for headings, normal for body)
- Proper text sizing without overriding system defaults
- Clear hierarchy with h1 for page titles, h2 for sections

### 3. Spacing and Layout
- Consistent padding and margins using Tailwind classes
- Responsive design with proper breakpoints (md:, lg:)
- Grid gaps of 4-6 units for card layouts
- Proper container max-widths and centering

## Responsive Design Requirements

### 1. Mobile First Approach
- Cards stack vertically on mobile (grid-cols-1)
- Statistics cards adapt to smaller screens
- Search and filter elements remain accessible
- Navigation optimized for touch interaction

### 2. Tablet and Desktop
- 2-3 column layouts for tablets (md:grid-cols-2 lg:grid-cols-3)
- Full feature set available on larger screens
- Proper spacing and visual balance
- Hover states for interactive elements

## Code Quality Standards

### 1. TypeScript Usage
- Strict type definitions for all entities and relationships
- Proper interface definitions for component props
- Type-safe data filtering and manipulation
- Generic types for reusable components

### 2. Component Organization
- Single responsibility principle for components
- Reusable card components with consistent interfaces
- Separation of concerns between data and presentation
- Clean import/export structure

### 3. Performance Considerations
- Efficient filtering and search implementations
- Proper key props for rendered lists
- Minimal re-renders with appropriate state management
- Lazy loading considerations for large datasets

## Example Prompt Structure

When prompting an AI coder, structure your request as follows:

1. **Context Setting**: Explain the three-way business relationship
2. **Technical Requirements**: Specify React, TypeScript, Tailwind, shadcn/ui
3. **Feature Specifications**: List required dashboards and functionality
4. **Design References**: Reference the existing system's visual style
5. **Data Requirements**: Specify the entity relationships and mock data needs
6. **Component Structure**: Outline the expected file organization

## Success Criteria

The completed system should:
- Provide clear, role-specific dashboards for all three user types
- Display comprehensive statistics and relationship data
- Include functional search and filtering across all views
- Maintain visual consistency with professional design standards
- Handle responsive layout changes gracefully
- Use proper TypeScript types throughout
- Follow established component patterns and naming conventions