# iA Presenter Theme Structure

A custom theme is typically a folder (e.g., `MyTheme/`) containing specific configuration files.

## File Layout

```text
MyTheme/
├── style.css       # (Required) Main styling for slides
├── template.json   # (Required) Metadata (Name, Fonts)
├── presets.json    # (Optional) CSS variable presets
├── fonts/          # (Optional) Custom font files (.woff2, etc.)
└── assets/         # (Optional) Background images, logos
```

## JSON Files (Hypothetical Structure)

Since official schemas are not public, use these as starting points based on common app patterns.

**template.json**:

```json
{
  "name": "My Custom Theme",
  "author": "User Name",
  "version": "1.0",
  "fonts": {
    "body": "MyCustomFont",
    "title": "MyCustomTitleFont"
  }
}
```

## CSS Targeting

iA Presenter slides are HTML. Use standard CSS.

- Target `body` for global backgrounds.
- Target `h1`, `h2`, `p` for typography.
- Use `@media` queries for different screen sizes (Mobile is often the default "base" style in iA Presenter, with desktop overrides).
