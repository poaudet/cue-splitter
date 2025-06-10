# 🎶 cue-splitter

**cue-splitter** is a Dockerized tool to automatically:

- Detect subfolders containing a single `.cue` + one music file (`.flac`, `.ape`, `.wav`)
- Split the full album into individual track files using `shnsplit`
- Apply proper metadata tags to each track using `cuetag.sh`
- Ideal for preparing music libraries (e.g., for Plex)

---

## 📦 Features

- Lightweight Ubuntu-based container
- Works with `.flac`, `.ape`, or `.wav` single-file albums
- Tags tracks using metadata from `.cue`
- Safe: does not delete or move original files by default

---

## 🛠 Requirements

- Docker installed
- Music folder with subfolders like:
```

/music/Album/
├── album.cue
└── album.flac

````

---

## 🚀 Usage

### 1. Clone this repo and build the image

```bash
docker build -t cue-splitter .
````

### 2. Run with your music folder

```bash
docker run --rm -v /path/to/your/music:/music cue-splitter
```

This will:

* Recursively scan each folder inside `/music`
* Split and tag if it finds:

  * 1 `.cue` file
  * 1 matching audio file

---

## 🔄 Customization

After testing the dry run, you can optionally:

* Delete originals:
  Add this to the end of `entrypoint.sh`:

  ```bash
  rm -f "$audio" "$cue"
  ```

* Move originals:

  ```bash
  mkdir -p _originals
  mv "$audio" "$cue" _originals/
  ```

---

## 📁 Project Structure

```
.
├── Dockerfile         # Ubuntu-based image with required tools
├── entrypoint.sh      # Main logic: find, split, tag
├── cuetag.sh          # Script to apply tags to split tracks
└── README.md
```

---

## 🙋 FAQ

**Q: Does it overwrite existing split files?**
A: No. If `split-track*.flac` files already exist, it will overwrite them silently. Back up if needed.

**Q: Can I add more formats like `.mp3`?**
A: Yes, but you'll need to install `lame` or other encoders and adjust the script.

---

## 🧑‍💻 License

MIT — use freely and modify as needed.
