# GitHub Repository Metadata — TODO

These settings cannot be changed from within the repo. Apply them manually via the GitHub UI
or the `gh` CLI commands below.

---

## 1. Description

Go to: **Settings → General → Description**

Paste:
```
66 production-ready QML examples — avionics HUDs & PFDs, industrial HMIs, shaders, charts, and Qt Quick controls (Qt 6)
```

---

## 2. Website

Go to: **Settings → General → Website**

Paste your LinkedIn or personal site URL:
```
https://www.linkedin.com/in/jesus-ramos-membrive-91a896101
```

---

## 3. Topics

Go to: **Settings → General → Topics** (click the gear icon next to "About")

Add all of these:
```
qml
qt6
qt-quick
qt
cpp
hmi
dashboard
industrial-ui
embedded-ui
avionics
qt-components
qml-components
qt-examples
```

---

## 4. Social Preview

Consider uploading a banner image (1280×640px) to:
**Settings → General → Social preview**

Tip: create a collage of 4–6 GIFs using ffmpeg:
```bash
ffmpeg -i gifs/HUD.gif -i gifs/PrimaryFlightDisplay.gif -i gifs/NavigationDisplay.gif -i gifs/ECAM.gif \
  -filter_complex "[0:v][1:v]hstack=inputs=2[top];[2:v][3:v]hstack=inputs=2[bot];[top][bot]vstack" \
  -frames:v 1 social_preview.png
```
Or use ezgif.com → "GIF to video" → screenshot a frame.

---

## 5. GitHub CLI equivalent (optional)

If you prefer the terminal, run these commands (requires `gh auth login`):

```bash
gh repo edit JesusRamosMembrive/QML-SnippetsExamples \
  --description "66 production-ready QML examples — avionics HUDs & PFDs, industrial HMIs, shaders, charts, and Qt Quick controls (Qt 6)" \
  --homepage "https://www.linkedin.com/in/[YOUR-LINKEDIN-HANDLE]"

gh repo edit JesusRamosMembrive/QML-SnippetsExamples \
  --add-topic qml \
  --add-topic qt6 \
  --add-topic qt-quick \
  --add-topic qt \
  --add-topic cpp \
  --add-topic hmi \
  --add-topic dashboard \
  --add-topic industrial-ui \
  --add-topic embedded-ui \
  --add-topic avionics \
  --add-topic qt-components \
  --add-topic qml-components \
  --add-topic qt-examples
```

---

## 6. Placeholders to fill in README files

Search for `jesus-ramos-membrive-91a896101` in:
- `README.md`
- `README.es.md`

And replace with your actual LinkedIn profile handle.

---

## 7. License consideration (optional)

The repo currently uses **GPL-3.0**. If you want broader adoption (companies copying snippets
freely), consider switching to **MIT**. Open a GitHub issue titled "Consider relicensing to MIT"
and link it from the License section in README.md.
