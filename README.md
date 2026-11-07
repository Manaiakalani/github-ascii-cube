# 🎲 GitHub ASCII Cube

A faithful recreation of the 3D ASCII cube from the [GitHub Shop](https://thegithubshop.com) footer: a rotating cube textured with the GitHub Mona logo, rendered entirely as ASCII art using a custom GLSL post-processing shader.

```
     . . < < > > # #
   . . < < > > # # . .
 . . < < > > # # . . < <
 . < < > > # # . . < < >
 . < > > # # . . < < > >
 . < > > # # . . < < > >
 . < < > > # # . . < < >
 . . < < > > # # . . < <
   . . < < > > # # . .
     . . < < > > # #
```

## ✨ Features

- **GPU-powered ASCII rendering**: GLSL fragment shader converts the 3D scene to ASCII in real-time
- **Faithful reproduction**: same geometry, shader, character ramp (`' ..<>#'`), and animation as the original
- **Interactive controls**: arrow keys, click+drag, touch drag
- **Rainbow mode**: toggle gradient color shader with the 🎨 button
- **Responsive**: adaptive cell sizes across 4 breakpoints (mobile → desktop)
- **Zero dependencies**: single HTML file, Three.js loaded from CDN
- **Dockerized**: serve with `docker compose up`

## 🚀 Quick Start

### Open directly

Just open `index.html` in a modern browser (Chrome, Edge, Firefox, Safari 17+).

### With a local server

```bash
# Python
python -m http.server 8080 -d .

# Node.js
npx serve .
```

### With Docker

```bash
docker compose up -d
# → http://localhost:8080
```

Or build manually:

```bash
docker build -t github-ascii-cube .
docker run -p 8080:80 github-ascii-cube
```

## 🎮 Controls

| Input | Action |
|---|---|
| `←` `→` | Rotate left / right |
| `↑` `↓` | Rotate up / down |
| Click + drag | Free rotation |
| Touch + drag | Free rotation (mobile) |
| ⏸ Pause | Stop / resume auto-rotation |
| 🎨 Color | Toggle rainbow gradient mode |

## 🔧 How It Works

Unlike CPU-based ASCII art, this uses a **GPU shader pipeline**:

1. A subdivided `BoxGeometry(50,50,50,32,32,32)` is textured with the Mona image and rendered with Three.js
2. The frame passes through an `EffectComposer` → `RenderPass` → `ShaderPass` pipeline
3. A custom fragment shader:
   - Pixelizes the scene into a grid based on cell size
   - Converts each cell to greyscale (ITU-R BT.709 luminance)
   - Maps brightness to one of 6 ASCII characters from a pre-rendered atlas
   - Applies Laplacian sharpening + smoothstep for crisp edges
4. Rotation uses quaternion SLERP with damping factor 0.25 for smooth momentum

## 🏗️ Architecture

```
index.html          ← Main app (Three.js + GLSL shader, self-contained)
about.html          ← Project info & tech details
Dockerfile          ← nginx:alpine container
docker-compose.yml  ← One-command deploy
```

## ⚡ Performance

- **Zero GC pressure**: reusable Three.js objects in animation loop & input handlers
- **DPR capped at 2×**: prevents 9× framebuffer bloat on high-DPR mobile devices
- **Debounced resize** with GPU texture disposal
- **Auto-pause** when tab is hidden (`visibilitychange`)
- **Responsive cell sizing**: 4px / 5px / 6px / 9px across breakpoints

## 📄 License

[MIT](LICENSE)

---

Built by [@Manaiakalani](https://github.com/Manaiakalani)
