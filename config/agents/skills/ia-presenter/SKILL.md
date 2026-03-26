---
name: ia-presenter
description: Create and edit presentations for iA Presenter using Markdown. Use when the user wants to write slides, create a deck, or format text for iA Presenter.
---

# iA Presenter Workflow Guide

## Core Philosophy: Fast and Focused

iA Presenter inverts the traditional presentation creation process.

1.  **Content First**: Write the script (message) first.
2.  **Design Last**: Apply layout and design only after the story is solid.
3.  **Separation of Concerns**: Strictly separate "What you say" (Script/Notes) from "What you show" (Slides/Visuals).

## The 5-Step Process

### 1. Write (Script First)

Start by writing the narrative as a plain text document (or email).

- Focus entirely on the message and story flow.
- Do not worry about slide breaks or visuals yet.
- Use **Placeholder Images** (e.g., `/assets/image.jpg`) to keep moving fast.
- _Note_: For local images, drop them into iA Presenter's **Media Manager**.

### 2. Structure (Slide Breaks)

Once the script is written, chop it into slides.

- **Split**: Use `---` (three dashes) on a separate line OR **3 Return keys** to create a new slide.
- **One Idea Per Slide**: Keep slides focused.
- **Visibility**:
  - **Headers** (`#`, `##`): Always visible on slide.
  - **Tables**: Markdown tables are always visible on the slide.
  - **Body Text**: Add a **Tab (\t)** to make a paragraph visible on the slide. **Space indentation will not work.**
  - **Speaker Notes**: Keep text **unindented** to make it invisible to the audience (teleprompter only).

### 3. Iterate (Refine & Layout Control)

Review and refine the flow and automatic layout.

- **Avoid Content Overload**: iA Presenter automatically uses **Split** or **Grid** layouts when multiple visible elements (tab-indented text blocks, images, tables) are present on a single slide.
- **Minimize Visible Blocks**: To prevent text from becoming too small or layouts from becoming cluttered, aim for **one major visible element** per slide.
- **Heading & Content Grouping**: Do **NOT** place an empty line between a Heading (`#`) and subsequent visible content (like tab-indented lists `\t-` or text). An empty line forces them into separate layout cells, causing unwanted Split or Grid views. Keep them strictly adjacent to treat them as a single unit.
- **Avoid Automatic Grid/Split**: If visible elements are separated by lines, they may be forced into a Grid. To keep elements together, avoid unnecessary line breaks between them if they belong to the same visual unit, or use a list.
- **Slide Splitting**: If the layout looks cramped (too many Grid items), it's a signal to split the content into multiple slides.

### 4. Design (Layouts & Themes)

Apply visual styling only after the structure is locked.

- Select a Theme (fonts/colors).
- **Auto-Layout**: The app handles responsive layout.
- **Image Parameters**: You can control image positioning directly in Markdown by adding parameters immediately after the image link/URL.
  ```markdown
  /assets/image.jpg
  x: left
  y: top
  size: contain
  ```
- **Layout Picker**: Choose between Stack, Split, Grid, etc., for multi-element slides via the UI or let the auto-layout handle it.

### 5. Action (Finalize)

- Prepare for the Teleprompter.
- Export to PDF/Handout if needed.

## Quick Reference

### Markdown & Syntax

| Feature           | Syntax                               | Details                               |
| :---------------- | :----------------------------------- | :------------------------------------ | --- | --- | -------------- |
| **Slide Break**   | `---` or 3x Return                   | Separator                             |
| **Visible Text**  | `\tText` or `    Text`               | Tab or 4 spaces indent                |
| **Speaker Notes** | `Text` (No indent)                   | Visible only in teleprompter          |
| **Headings**      | `#` (H1) to `######` (H6)            | H1=Cover, H2=Title, H3-H6=Subsections |
| **Emphasis**      | `**bold**`, `*italic*`, `~~strike~~` | `==highlight==`, `^sup^`, `~sub~`     |
| **Lists**         | `-`, `*`, `1.`, `- [ ]`              | Tab-indent to show on slide           |
| **Quotes**        | `>` (Notes), `⇥>` (Slide)            | Use `⇥>` to show quote on slide       |
| **Footnotes**     | `[^1]` ... `[^1]: Text`              | Auto-numbered                         |
| **Math (LaTeX)**  | `$x^2$` or `$$x^2$$`                 | Inline or Block                       |
| **Tables**        | `                                    | A                                     | B   | `   | Always visible |
| **Comments**      | `// Comment`                         | Hidden everywhere                     |

### Media & Assets

**Supported Formats**:

- **Images**: PNG, JPG, GIF, WEBP, SVG, PDF, TIFF.
- **Video**: MP4, MOV, M4V.
- **Audio**: MP3, WAV, AAC, FLAC, M4A.

**Adding Media**:

- **Drag & Drop**: Automatically handles pathing.
- **Markdown**: `/assets/image.jpg` or `/assets/video.mp4`
- **Asset Path**: Local files in `/assets/` or remote URLs.

**Visual Parameters** (Add after image/video link):

```markdown
/assets/image.jpg
background: true
opacity: 50%
filter: blur
```

- **Position**: `x: left/center/right`, `y: top/center/bottom`
- **Sizing**: `size: cover/contain`
- **Filters**: `lighten`, `darken`, `grayscale`, `sepia`, `blur`

### Layout Logic

Presenter automates layout based on content structure ("Cells"):

- **One Block**: A heading, image, or text block forms a "Cell".
- **Separation**: Two empty lines break content into separate cells/columns.
- **Grid Generation**: 4+ items automatically form a Grid layout.
- **Split View**: 2-3 items separated by double-newlines display side-by-side.
- **Layout Picker**: Manually override auto-layout via the UI (Stack, Split, Grid, Caption, etc.).

**Note**: Avoid Grid and Split layouts whenever possible. Single-focus slides are generally more effective for clarity and audience engagement. If content triggers a Grid, consider splitting it into multiple slides.
