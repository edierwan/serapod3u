import { test, expect } from '@playwright/test';

test.describe('CTA Visibility Tests', () => {
  test.beforeEach(async ({ page }) => {
    // Login first (assuming fast login is enabled)
    await page.goto('/login');
    await page.getByRole('button', { name: 'Fast Login' }).click();
    await page.waitForURL('/dashboard');
  });

  test('Variants empty state CTA is visible', async ({ page }) => {
    await page.goto('/master/variants');

    // Check if we're on empty state (no products)
    const emptyState = page.locator('[data-testid="empty-state"]').or(
      page.locator('text=Create a product first')
    );

    if (await emptyState.isVisible()) {
      const primaryButton = page.locator('button:has-text("Create Product")');
      await expect(primaryButton).toBeVisible();

      // Check opacity is not too low (should be visible)
      const opacity = await primaryButton.evaluate(el =>
        window.getComputedStyle(el).opacity
      );
      expect(parseFloat(opacity)).toBeGreaterThan(0.5);
    }
  });

  test('Manufacturers empty state CTA is visible', async ({ page }) => {
    await page.goto('/master/manufacturers');

    // Check if we're on empty state
    const emptyState = page.locator('text=No manufacturers found');

    if (await emptyState.isVisible()) {
      const primaryButton = page.locator('button:has-text("Add Manufacturer")');
      await expect(primaryButton).toBeVisible();

      // Check opacity is not too low
      const opacity = await primaryButton.evaluate(el =>
        window.getComputedStyle(el).opacity
      );
      expect(parseFloat(opacity)).toBeGreaterThan(0.5);
    }
  });

  test('Products create button is visible', async ({ page }) => {
    await page.goto('/master/products');

    const createButton = page.locator('button:has-text("Create Product")').or(
      page.locator('a:has-text("Create Product")')
    );
    await expect(createButton).toBeVisible();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.5);
  });

  test('Brands create button is visible', async ({ page }) => {
    await page.goto('/master/brands');

    const createButton = page.locator('button:has-text("Add Brand")').or(
      page.locator('a:has-text("Add Brand")')
    );
    await expect(createButton).toBeVisible();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.5);
  });

  test('Categories create button is visible', async ({ page }) => {
    await page.goto('/master/categories');

    const createButton = page.locator('button:has-text("Add Category")').or(
      page.locator('a:has-text("Add Category")')
    );
    await expect(createButton).toBeVisible();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.5);
  });

  test('Product Groups create button is visible', async ({ page }) => {
    await page.goto('/master/product-groups');

    const createButton = page.locator('button:has-text("Add Product Group")').or(
      page.locator('a:has-text("Add Product Group")')
    );
    await expect(createButton).toBeVisible();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.5);
  });

  test('Distributors create button is visible', async ({ page }) => {
    await page.goto('/master/distributors');

    const createButton = page.locator('button:has-text("Create Distributor")');
    await expect(createButton).toBeVisible();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.5);
  });

  test('Shops create button is visible', async ({ page }) => {
    await page.goto('/master/shops');

    const createButton = page.locator('button:has-text("Create Shop")');
    await expect(createButton).toBeVisible();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.5);
  });
});