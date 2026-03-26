---
name: ia-presenter-theme
description: Create custom visual themes for iA Presenter. Use when the user wants to customize the look, fonts, or colors of their slides beyond the built-in defaults.
---

# iA Presenter Theme Creator

## Overview

Custom themes allow you to style iA Presenter slides using standard CSS and JSON configuration.

## Workflow

1.  **Create**: Start a new theme via `Settings > Themes > + > Create Theme`. This generates the basic folder structure.
2.  **Edit**:
    - **`Theme.css`**: The core visual styling.
    - **`template.json`**: Metadata and font definitions.
    - **`presets.json`**: CSS variables and color palettes.
3.  **Inspect**: Use the in-app "Inspector" (Theme & Style tabs) to test changes instantly.
4.  **Refine**: Place custom fonts/images in the theme folder and reference them relatively.

## Theme Architecture

### File Structure

```text
MyTheme.iaTheme/
├── Theme.css       # Main stylesheet
├── template.json   # Theme metadata & font registration
├── presets.json    # Color palettes & gradients
├── my-font.woff2   # Custom font files
└── background.jpg  # Theme assets
```

### CSS Selectors & Layouts

iA Presenter generates `slide container` and `slide background` elements.

- **Global**:
  - `.slide-container`: The main wrapper for slide content.
  - `.slide-background`: The layer behind content (for images/colors).
- **Layout-Specific**:
  - `.layout-cover` / `.cover-container`: Title slides.
  - `.layout-title` / `.title-container`: Standard headers.
  - `.grid-items-2`, `.grid-items-3`...: Auto-generated grids.
  - `.v-split-container`: Vertical split layouts.
- **Components**:
  - `.header`, `.footer`: Page metadata (can `display: none`).
  - `.caption`: Image captions.

### Styling & Configuration

**1. Typography (`template.json`)**
Register fonts here before using them in CSS.

```json
{
  "fonts": {
    "display": {
      "fileName": "MyFont-Bold.woff2",
      "cssName": "MyFontBold"
    }
  }
}
```

_Then in CSS:_ `h1 { font-family: "MyFontBold"; }`

**2. Variables (`presets.json`)**
Define colors to appear in the app's style picker.

```json
{
  "colors": {
    "accent": "#FF5733",
    "background": "#FFFFFF"
  }
}
```

_Usage:_ `var(--accent)`

**3. Backgrounds & Images**

- Reference local assets: `background-image: url("bg.jpg");`
- Target specific backgrounds: `.backgrounds .cover-container { ... }`

**4. Responsive Design**

- **Mobile First**: Default styles apply to mobile.
- **Desktop**: Use `@media (min-width: 768px) { ... }` for larger screens.

## Best Practices

- Keep it simple. iA Presenter is about minimalism.
- Test with high contrast colors.
- Ensure text is legible on large screens.
