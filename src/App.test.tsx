import { render, screen } from '@testing-library/react';
import App from './App';
import { describe, it, expect } from 'vitest';
import React from 'react';

describe('App', () => {
  it('renders the header correctly', () => {
    render(<App />);
    expect(screen.getByText('Word Puzzle Solver')).toBeInTheDocument();
  });
});
