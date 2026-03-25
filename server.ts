import express from 'express';
import { createServer as createViteServer } from 'vite';
import path from 'path';
import fs from 'fs';

async function startServer() {
  const app = express();
  const PORT = Number(process.env.PORT ?? 8080);

  app.use(express.json());

  // Mock Clojure Backend API
  app.post('/api/solve', (req, res) => {
    const {
      letters,
      size = 4,
      repeats = false,
      dictionary = 'resources/dictionary',
    } = req.body;

    if (!letters || letters.length < 7) {
      return res
        .status(400)
        .json({ error: 'Required 7+ letters not provided.' });
    }

    if (!/^[a-zA-Z]+$/.test(letters)) {
      return res
        .status(400)
        .json({ error: 'Letters must only contain alphabetical characters.' });
    }

    // Validate dictionary path to prevent path traversal attacks.
    // Normalise first to resolve '.', '..', and duplicate slashes, then
    // require the result to stay within the 'resources/' directory.
    const dictionaryPath = path.normalize(String(dictionary));
    if (!dictionaryPath.startsWith('resources/')) {
      return res.status(400).json({
        error:
          "Invalid dictionary path. Must be within the 'resources/' directory.",
      });
    }

    // Read dictionary file
    let dictionaryContent = '';
    try {
      // Try the provided path, fallback to .txt if not found
      const fullPath = path.join(process.cwd(), dictionaryPath);
      if (fs.existsSync(fullPath)) {
        dictionaryContent = fs.readFileSync(fullPath, 'utf8');
      } else if (fs.existsSync(fullPath + '.txt')) {
        dictionaryContent = fs.readFileSync(fullPath + '.txt', 'utf8');
      } else {
        return res
          .status(404)
          .json({ error: `Dictionary file not found: ${dictionaryPath}` });
      }
    } catch (err) {
      return res.status(500).json({ error: 'Failed to read dictionary file.' });
    }

    const allWords = dictionaryContent
      .split(/\r?\n/)
      .map((w) => w.trim())
      .filter((w) => w.length > 0);
    const inputLetters = letters.toLowerCase();
    const mandatoryLetter = inputLetters[0];
    const availableLetters = inputLetters.split('');

    const solvedWords = allWords
      .filter((word) => {
        const wordLower = word.toLowerCase();

        // 1. Minimum size
        if (wordLower.length < size) return false;

        // 2. Must contain the mandatory letter (first letter of input)
        if (!wordLower.includes(mandatoryLetter)) return false;

        // 3. Must only use provided letters
        const wordLetters = wordLower.split('');

        if (repeats) {
          // Any letter in word must be in availableLetters
          return wordLetters.every((l: string) => availableLetters.includes(l));
        } else {
          // Each letter in word must be available in inputLetters (count-based)
          const counts: Record<string, number> = {};
          availableLetters.forEach(
            (l: string) => (counts[l] = (counts[l] || 0) + 1),
          );
          for (const l of wordLetters) {
            if (!counts[l]) return false;
            counts[l]--;
          }
          return true;
        }
      })
      .sort((a, b) => b.length - a.length || a.localeCompare(b));

    res.json(solvedWords);
  });

  // Vite middleware for development
  if (process.env.NODE_ENV !== 'production') {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: 'spa',
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), 'dist');
    app.use(express.static(distPath));
    app.get('/{*path}', (req, res) => {
      res.sendFile(path.join(distPath, 'index.html'));
    });
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

startServer();
