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
      const primaryButton = page.locator('[data-testid="cta-primary"]');
      await expect(primaryButton).toBeVisible();
      await expect(primaryButton).toBeEnabled();

      // Check it's not transparent
      const opacity = await primaryButton.evaluate(el =>
        window.getComputedStyle(el).opacity
      );
      expect(parseFloat(opacity)).toBeGreaterThan(0.8);

      // Check it has proper background color (not white/transparent)
      const backgroundColor = await primaryButton.evaluate(el =>
        window.getComputedStyle(el).backgroundColor
      );
      expect(backgroundColor).not.toBe('rgba(0, 0, 0, 0)');
      expect(backgroundColor).not.toBe('transparent');
    }
  });

  test('Manufacturers empty state CTA is visible', async ({ page }) => {
    await page.goto('/master/manufacturers');

    // Check if we're on empty state
    const emptyState = page.locator('[data-testid="empty-state"]');

    if (await emptyState.isVisible()) {
      const primaryButton = page.locator('[data-testid="cta-primary"]');
      await expect(primaryButton).toBeVisible();
      await expect(primaryButton).toBeEnabled();

      // Check it's not transparent
      const opacity = await primaryButton.evaluate(el =>
        window.getComputedStyle(el).opacity
      );
      expect(parseFloat(opacity)).toBeGreaterThan(0.8);
    }
  });

  test('Products create button is visible', async ({ page }) => {
    await page.goto('/master/products');

    const createButton = page.locator('[data-testid="cta-create-product"]');
    await expect(createButton).toBeVisible();
    await expect(createButton).toBeEnabled();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.8);
  });

  test('Brands create button is visible', async ({ page }) => {
    await page.goto('/master/brands');

    const createButton = page.locator('[data-testid="cta-create-brand"]');
    await expect(createButton).toBeVisible();
    await expect(createButton).toBeEnabled();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.8);
  });

  test('Categories create button is visible', async ({ page }) => {
    await page.goto('/master/categories');

    const createButton = page.locator('[data-testid="cta-create-category"]');
    await expect(createButton).toBeVisible();
    await expect(createButton).toBeEnabled();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.8);
  });

  test('Product Groups create button is visible', async ({ page }) => {
    await page.goto('/master/product-groups');

    const createButton = page.locator('[data-testid="cta-create-group"]');
    await expect(createButton).toBeVisible();
    await expect(createButton).toBeEnabled();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.8);
  });

  test('Sub-Groups create button is visible', async ({ page }) => {
    await page.goto('/master/subgroups');

    const createButton = page.locator('[data-testid="cta-create-subgroup"]');
    await expect(createButton).toBeVisible();
    await expect(createButton).toBeEnabled();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.8);
  });

  test('Variants create button is visible', async ({ page }) => {
    await page.goto('/master/variants');

    // Only check if we have products (variants can be created)
    const createButton = page.locator('[data-testid="cta-create-variant"]');
    const isVisible = await createButton.isVisible();
    if (isVisible) {
      await expect(createButton).toBeEnabled();

      // Check opacity is not too low
      const opacity = await createButton.evaluate(el =>
        window.getComputedStyle(el).opacity
      );
      expect(parseFloat(opacity)).toBeGreaterThan(0.8);
    }
  });

  test('Manufacturers create button is visible', async ({ page }) => {
    await page.goto('/master/manufacturers');

    const createButton = page.locator('[data-testid="cta-create-manufacturer"]');
    await expect(createButton).toBeVisible();
    await expect(createButton).toBeEnabled();

    // Check opacity is not too low
    const opacity = await createButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.8);
  });

  test('Modal save button is visible and keyboard accessible', async ({ page }) => {
    await page.goto('/master/categories');

    // Click create button to open modal
    await page.locator('[data-testid="cta-create-category"]').click();

    // Wait for modal to appear
    const saveButton = page.locator('[data-testid="cta-save"]');
    await expect(saveButton).toBeVisible();
    await expect(saveButton).toBeEnabled();

    // Check focus is accessible
    await saveButton.focus();
    const isFocused = await saveButton.evaluate(el => el === document.activeElement);
    expect(isFocused).toBe(true);

    // Check opacity
    const opacity = await saveButton.evaluate(el =>
      window.getComputedStyle(el).opacity
    );
    expect(parseFloat(opacity)).toBeGreaterThan(0.8);
  });

  test('Manufacturers create form active toggle persists', async ({ page }) => {
    await page.goto('/master/manufacturers');

    // Click create button
    await page.locator('[data-testid="cta-create-manufacturer"]').click();

    // Check that Active is checked by default
    const toggle = page.locator('input[name="is_active"]');
    await expect(toggle).toBeChecked();

    // Uncheck it
    await toggle.uncheck();
    await expect(toggle).not.toBeChecked();

    // Fill required field
    await page.fill('input[name="name"]', 'Test Manufacturer');

    // Submit
    await page.locator('[data-testid="cta-save"]').click();

    // Check that the new manufacturer shows Inactive
    const inactiveBadge = page.locator('text=Inactive').first();
    await expect(inactiveBadge).toBeVisible();
  });

  test('Manufacturers create form logo starts empty', async ({ page }) => {
    await page.goto('/master/manufacturers');

    // Click create button
    await page.locator('[data-testid="cta-create-manufacturer"]').click();

    // Check that logo shows placeholder, not an image
    const logoPlaceholder = page.locator('text=Logo');
    await expect(logoPlaceholder).toBeVisible();

    // No image should be present
    const logoImage = page.locator('img[alt="Logo"]');
    await expect(logoImage).not.toBeVisible();
  });
});