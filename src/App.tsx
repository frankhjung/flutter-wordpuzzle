/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useMemo } from 'react';
import {
  Search,
  Settings2,
  RotateCcw,
  AlertCircle,
  ChevronRight,
  Filter,
  Type,
  Hash,
  Repeat,
  Book,
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

interface SolveParams {
  letters: string;
  size: number;
  repeats: boolean;
  dictionary: string;
}

export default function App() {
  const [params, setParams] = useState<SolveParams>({
    letters: '',
    size: 4,
    repeats: false,
    dictionary: 'resources/dictionary',
  });
  const [results, setResults] = useState<string[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [filterText, setFilterText] = useState('');
  const [filterLength, setFilterLength] = useState<number | null>(null);

  const validateInput = () => {
    if (params.letters.length < 7) {
      return 'Please enter at least 7 letters.';
    }
    if (!/^[a-z]+$/.test(params.letters)) {
      return 'Only lowercase letters (a-z) are allowed.';
    }
    return null;
  };

  const handleSolve = async (e: React.FormEvent) => {
    e.preventDefault();
    const validationError = validateInput();
    if (validationError) {
      setError(validationError);
      return;
    }

    setLoading(true);
    setError(null);
    setResults([]);

    try {
      const response = await fetch('/api/solve', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(params),
      });

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data.error || 'Failed to connect to the solver.');
      }

      const data = await response.json();
      if (data.length === 0) {
        setError('No words found for these parameters.');
      } else {
        setResults(data);
      }
    } catch (err) {
      setError(
        err instanceof Error ? err.message : 'A network error occurred.',
      );
    } finally {
      setLoading(false);
    }
  };

  const filteredResults = useMemo(() => {
    return results.filter((word) => {
      const matchesText = word.includes(filterText.toLowerCase());
      const matchesLength = filterLength ? word.length === filterLength : true;
      return matchesText && matchesLength;
    });
  }, [results, filterText, filterLength]);

  const groupedResults = useMemo(() => {
    const groups: Record<number, string[]> = {};
    filteredResults.forEach((word) => {
      const len = word.length;
      if (!groups[len]) groups[len] = [];
      groups[len].push(word);
    });
    return Object.entries(groups)
      .sort(([a], [b]) => Number(b) - Number(a))
      .map(([len, words]) => ({ length: Number(len), words }));
  }, [filteredResults]);

  return (
    <div className="min-h-screen bg-[#F8F9FA] text-[#202124] font-sans p-4 md:p-8">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <header className="mb-8 text-center">
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            className="inline-flex items-center gap-2 px-4 py-2 bg-white rounded-full shadow-sm border border-gray-100 mb-4"
          >
            <div className="w-2 h-2 bg-blue-500 rounded-full animate-pulse" />
            <span className="text-xs font-medium text-gray-500 uppercase tracking-wider">
              Word Puzzle Solver
            </span>
          </motion.div>
          <h1 className="text-4xl md:text-5xl font-bold tracking-tight mb-2">
            Find the hidden words.
          </h1>
          <p className="text-gray-500 max-w-lg mx-auto">
            Enter your letters and configurations to discover all possible word
            combinations from the dictionary.
          </p>
        </header>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
          {/* Input Form */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="lg:col-span-5"
          >
            <div className="bg-white rounded-3xl p-6 shadow-xl shadow-gray-200/50 border border-gray-100">
              <div className="flex items-center gap-2 mb-6">
                <Settings2 className="w-5 h-5 text-blue-600" />
                <h2 className="text-lg font-semibold">Configuration</h2>
              </div>

              <form onSubmit={handleSolve} className="space-y-6">
                {/* Letters Input */}
                <div>
                  <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-2">
                    <Type className="w-4 h-4" />
                    Letters (7+ required)
                  </label>
                  <input
                    type="text"
                    value={params.letters}
                    onChange={(e) =>
                      setParams({
                        ...params,
                        letters: e.target.value.toLowerCase(),
                      })
                    }
                    placeholder="e.g. abcdefg"
                    className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none text-lg tracking-widest font-mono"
                  />
                  <p className="mt-2 text-xs text-gray-400">
                    The first letter is often the mandatory center letter.
                  </p>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  {/* Min Size */}
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-2">
                      <Hash className="w-4 h-4" />
                      Min Size
                    </label>
                    <input
                      type="number"
                      min="1"
                      max="15"
                      value={params.size}
                      onChange={(e) =>
                        setParams({
                          ...params,
                          size: parseInt(e.target.value) || 4,
                        })
                      }
                      className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none"
                    />
                  </div>

                  {/* Repeats Toggle */}
                  <div>
                    <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-2">
                      <Repeat className="w-4 h-4" />
                      Repeats
                    </label>
                    <button
                      type="button"
                      onClick={() =>
                        setParams({ ...params, repeats: !params.repeats })
                      }
                      className={`w-full px-4 py-3 rounded-2xl border transition-all flex items-center justify-center gap-2 ${
                        params.repeats
                          ? 'bg-blue-50 border-blue-200 text-blue-700'
                          : 'bg-gray-50 border-gray-200 text-gray-500'
                      }`}
                    >
                      {params.repeats ? 'Enabled' : 'Disabled'}
                    </button>
                  </div>
                </div>

                {/* Dictionary */}
                <div>
                  <label className="flex items-center gap-2 text-sm font-medium text-gray-700 mb-2">
                    <Book className="w-4 h-4" />
                    Dictionary Path
                  </label>
                  <input
                    type="text"
                    value={params.dictionary}
                    onChange={(e) =>
                      setParams({ ...params, dictionary: e.target.value })
                    }
                    className="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-2xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all outline-none text-sm"
                  />
                </div>

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-2xl font-semibold shadow-lg shadow-blue-200 transition-all flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {loading ? (
                    <RotateCcw className="w-5 h-5 animate-spin" />
                  ) : (
                    <>
                      <Search className="w-5 h-5" />
                      Solve Puzzle
                    </>
                  )}
                </button>
              </form>

              <AnimatePresence>
                {error && (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: 'auto' }}
                    exit={{ opacity: 0, height: 0 }}
                    className="mt-6 p-4 bg-red-50 border border-red-100 rounded-2xl flex items-start gap-3 text-red-700 text-sm"
                  >
                    <AlertCircle className="w-5 h-5 flex-shrink-0" />
                    <p>{error}</p>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          </motion.div>

          {/* Results Section */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            className="lg:col-span-7"
          >
            <div className="bg-white rounded-3xl p-6 shadow-xl shadow-gray-200/50 border border-gray-100 min-h-[500px] flex flex-col">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                <div className="flex items-center gap-2">
                  <ChevronRight className="w-5 h-5 text-blue-600" />
                  <h2 className="text-lg font-semibold">
                    Results ({filteredResults.length})
                  </h2>
                </div>

                {results.length > 0 && (
                  <div className="flex items-center gap-2">
                    <div className="relative">
                      <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                      <input
                        type="text"
                        placeholder="Filter words..."
                        value={filterText}
                        onChange={(e) => setFilterText(e.target.value)}
                        className="pl-9 pr-4 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-500 outline-none w-full md:w-40"
                      />
                    </div>
                    <select
                      value={filterLength || ''}
                      onChange={(e) =>
                        setFilterLength(
                          e.target.value ? parseInt(e.target.value) : null,
                        )
                      }
                      className="px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:ring-2 focus:ring-blue-500 outline-none"
                    >
                      <option value="">All lengths</option>
                      {Array.from(new Set(results.map((w) => w.length)))
                        .sort((a: number, b: number) => b - a)
                        .map((len) => (
                          <option key={len} value={len}>
                            {len} letters
                          </option>
                        ))}
                    </select>
                  </div>
                )}
              </div>

              <div className="flex-grow overflow-y-auto max-h-[600px] pr-2 custom-scrollbar">
                {results.length === 0 && !loading && !error && (
                  <div className="h-full flex flex-col items-center justify-center text-gray-400 space-y-4">
                    <div className="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center">
                      <Search className="w-8 h-8 opacity-20" />
                    </div>
                    <p>Enter letters to see results</p>
                  </div>
                )}

                {loading && (
                  <div className="space-y-4">
                    {[1, 2, 3].map((i) => (
                      <div key={i} className="animate-pulse space-y-2">
                        <div className="h-4 bg-gray-100 rounded w-20" />
                        <div className="grid grid-cols-3 gap-2">
                          <div className="h-10 bg-gray-50 rounded-xl" />
                          <div className="h-10 bg-gray-50 rounded-xl" />
                          <div className="h-10 bg-gray-50 rounded-xl" />
                        </div>
                      </div>
                    ))}
                  </div>
                )}

                <div className="space-y-8">
                  {groupedResults.map(({ length, words }) => (
                    <div key={length} className="space-y-3">
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-bold text-blue-600 bg-blue-50 px-2 py-1 rounded uppercase tracking-wider">
                          {length} Letters
                        </span>
                        <div className="h-px flex-grow bg-gray-100" />
                        <span className="text-xs text-gray-400">
                          {words.length} words
                        </span>
                      </div>
                      <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                        {words.map((word) => (
                          <motion.div
                            key={word}
                            initial={{ opacity: 0, scale: 0.95 }}
                            animate={{ opacity: 1, scale: 1 }}
                            className="px-4 py-2 bg-gray-50 hover:bg-blue-50 border border-gray-100 hover:border-blue-100 rounded-xl text-sm font-medium transition-colors cursor-default text-center"
                          >
                            {word}
                          </motion.div>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </div>

      <style>{`
        .custom-scrollbar::-webkit-scrollbar {
          width: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
          background: transparent;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
          background: #E5E7EB;
          border-radius: 10px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
          background: #D1D5DB;
        }
      `}</style>
    </div>
  );
}
