import express from "express";
import { createServer as createViteServer } from "vite";
import path from "path";

async function startServer() {
  const app = express();
  const PORT = 3000;

  app.use(express.json());

  // Mock Clojure Backend API
  app.post("/api/solve", (req, res) => {
    const { letters, size = 4, repeats = false, dictionary = 'resources/dictionary' } = req.body;

    if (!letters || letters.length < 7) {
      return res.status(400).json({ error: "Required 7+ letters not provided." });
    }

    if (!/^[a-zA-Z]+$/.test(letters)) {
      return res.status(400).json({ error: "Letters must only contain alphabetical characters." });
    }

    // Validate dictionary path to prevent path traversal attacks.
    // Normalise first to resolve '.', '..', and duplicate slashes, then
    // require the result to stay within the 'resources/' directory.
    const dictionaryPath = path.normalize(String(dictionary));
    if (!dictionaryPath.startsWith('resources/')) {
      return res.status(400).json({ error: "Invalid dictionary path. Must be within the 'resources/' directory." });
    }

    // Mock solving logic: just returns some words based on input for demo
    // In a real scenario, this would call the Clojure jar or logic
    const mockWords = [
      "discover", "divorce", "divorces", "sidecar", "varicose", "viscera",
      "acid", "care", "case", "code", "core", "dare", "dear", "dice", "dive",
      "door", "dose", "dove", "race", "read", "ride", "rise", "road", "rose",
      "said", "save", "scar", "side", "sore", "vase", "vice", "voice"
    ].filter(word => {
      // Basic filter: must be at least 'size' long
      if (word.length < size) return false;
      
      // Must only use provided letters (if repeats is false, check counts)
      const inputLetters = letters.toLowerCase().split("");
      const wordLetters = word.toLowerCase().split("");
      
      if (repeats) {
        return wordLetters.every(l => inputLetters.includes(l));
      } else {
        const counts: Record<string, number> = {};
        inputLetters.forEach(l => counts[l] = (counts[l] || 0) + 1);
        for (const l of wordLetters) {
          if (!counts[l]) return false;
          counts[l]--;
        }
        return true;
      }
    }).sort((a, b) => b.length - a.length || a.localeCompare(b));

    res.json(mockWords);
  });

  // Vite middleware for development
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), 'dist');
    app.use(express.static(distPath));
    app.get('*', (req, res) => {
      res.sendFile(path.join(distPath, 'index.html'));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

startServer();
