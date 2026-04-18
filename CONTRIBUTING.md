# Contributing

Thank you for your interest in contributing to this QML examples collection!

## How to contribute

### Adding a new example page

The most valuable contribution is a new, well-crafted example page.

1. **Read the guide first:** [docs/CREATING_NEW_PAGE.md](docs/CREATING_NEW_PAGE.md)

2. **Fork and clone:**
   ```bash
   git clone https://github.com/<your-username>/QML-SnippetsExamples.git
   cd QML-SnippetsExamples
   ```

3. **Create a feature branch:**
   ```bash
   git checkout -b feature/my-example-page
   ```

4. **Set up the build** (point to your Qt installation):
   ```bash
   cmake -B build -S . -DCMAKE_PREFIX_PATH="/path/to/Qt/6.x.x/gcc_64"
   cmake --build build
   ```

5. **Implement your example page** following the structure in the guide.

6. **Verify a clean build:**
   ```bash
   rm -rf build && cmake -B build -S . && cmake --build build
   ```

7. **Record a GIF** of your example in action and place it in `gifs/`.

8. **Update [docs/GALLERY.md](docs/GALLERY.md)** with your new GIF and a one-line description.

9. **Open a pull request** against `master`.

### Fixing a bug

1. Open an issue first if one doesn't exist.
2. Reference the issue in your PR: `Fixes #123`.
3. Keep the fix focused — don't refactor unrelated code.

### Improving documentation

Typo fixes, clarifications, and translations are all welcome as direct PRs.

---

## Coding conventions

- Use `Style.resize(value)` for all dimensions — never hardcode pixel values.
- Use `Style.mainColor`, `Style.bgColor` etc. — never hardcode colors.
- Each example page **must** implement the `fullSize` bool property and the opacity animation.
- Follow the existing module naming pattern: library `mypageplugin`, link target `mypagepluginplugin`.

## Commit style

Use conventional commit prefixes where they fit:

```
feat: add Charts example page
fix: correct HUD pitch ladder rendering at high angles
docs: update GALLERY.md with Transforms GIF
```

---

## Requirements

- Qt 6.4+, CMake 3.16+, C++17 compiler
- See [README.md](README.md) for full setup instructions.
