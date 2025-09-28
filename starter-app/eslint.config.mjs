import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

const eslintConfig = [
  // Ignore generated files
  {
    ignores: [
      '**/node_modules/**',
      '**/.next/**',
      '**/dist/**',
      '**/build/**',
      '**/coverage/**',
      '**/.turbo/**',
    ],
  },
  ...compat.extends("next/core-web-vitals", "next/typescript"),
  // Allow triple-slash only for Next's auto file
  {
    files: ['next-env.d.ts'],
    rules: {
      '@typescript-eslint/triple-slash-reference': 'off',
    },
  },
  // Scope type-aware rules to our source only
  {
    files: ['app/**/*.{ts,tsx}', 'components/**/*.{ts,tsx}', 'lib/**/*.{ts,tsx}'],
    rules: {
      "@typescript-eslint/no-unused-vars": "error",
      "@typescript-eslint/no-explicit-any": "warn",
      "@typescript-eslint/no-empty-object-type": "error",
      "prefer-const": "error",
      // Prevent invisible primary buttons
      "no-restricted-syntax": [
        "error",
        {
          selector: "JSXElement:has(JSXAttribute[name='variant'][value.value='primary']) JSXAttribute[name='className'][value.value=/\\b(opacity-0|text-transparent|bg-transparent)\\b/]",
          message: "Primary buttons must remain visible. Do not use opacity-0, text-transparent, or bg-transparent on primary variant buttons."
        },
        {
          selector: "JSXElement:has(JSXAttribute[name='type'][value.value='submit']) JSXAttribute[name='className'][value.value=/\\b(opacity-0|text-transparent|bg-transparent)\\b/]",
          message: "Submit buttons must remain visible. Do not use opacity-0, text-transparent, or bg-transparent on submit buttons."
        },
        {
          selector: "JSXElement[name='button']:not(:has(JSXAttribute[name='variant']))",
          message: "Use the shared Button component with explicit variant. Raw <button> elements are not allowed."
        },
        {
          selector: "JSXElement[name='Link']:has(JSXAttribute[name='className'][value.value=/\\b(bg-blue-600|text-white)\\b/])",
          message: "Use Button component with asChild prop instead of styling Link elements directly."
        }
      ]
    },
  },
];

export default eslintConfig;