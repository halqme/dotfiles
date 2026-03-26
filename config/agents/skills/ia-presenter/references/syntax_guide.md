# iA Presenter Markdown Syntax Guide

iA Presenter uses a specific Markdown flavor to distinguish between the speaker's script and the audience's visual aids.

## 1. Slide Separation

The primary separator is **three dashes** on a blank line.

```markdown
Slide 1 content...

---

Slide 2 content...
```

## 2. Text Visibility

### Visible on Slide (Visuals)

To show text on the slide, you must **explicitly** mark it.

- **Headings**: `# H1`, `## H2` are always visible.
- **Indented Text**: Paragraphs indented with a **Tab** (or 4 spaces) appear on the slide.

```markdown
# This is a Slide Title

    This paragraph is indented.
    It will appear on the slide screen.
```

### Invisible (Speaker Notes)

Any standard, unindented text is treated as **Speaker Notes**. It appears only in the Teleprompter.

```markdown
# Slide Title

This text is NOT indented. It is my script.
I will read this out loud, but the audience will not see it text on screen.
```

## 3. Images and Visuals

Images, Videos, and Tables are **visible by default**.

```markdown
![Description](image.jpg)
```

### Image Configuration

You can control image positioning and sizing using metadata variables immediately following the image link.

**Positioning (`x`, `y`):**

- `x`: `left`, `center`, `right`
- `y`: `top`, `center`, `bottom`

**Sizing (`size`):**

- `size`: `contain` (fit within slide), `cover` (fill slide), `original`

**Example:**

```markdown
![My Image](assets/photo.jpg)
x: left
y: top
size: contain
```

### Placeholder Images

For rapid drafting, use placeholders or existing assets.

```markdown
/Theme/image2.webp
title: "Placeholder"
```

## 4. Layouts

When a slide has multiple elements (e.g., two images, or text + image), iA Presenter automatically chooses a responsive layout. You can force specific arrangements in the app's Layout Picker, but the Markdown order defines the hierarchy.

## 5. Complete Example

```markdown
# The Project Vision

    We are building the future of...

Actually, we are just making a simple tool. But it sounds better.

---

![Prototype](images/proto.png)
size: contain

# The Prototype

    1. Fast
    2. Reliable
    3. Cheap

As you can see in this prototype, we focused on speed first.
```
