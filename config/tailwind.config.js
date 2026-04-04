// config/tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
    fontFamily: {
      sans:  ['"Noto Sans JP"', 'sans-serif'],
      title: ['"Libre Baskerville"', 'serif'],
    },
      colors: {
        sage: {
          50:  '#F4F8F4',
          100: '#E6F0E6',
          200: '#C8D9C8',
          300: '#A9C1A9',
          400: '#7BAD7B',
          500: '#6A9E6A',
          600: '#4A7A4A',
          700: '#1E4D19',
          800: '#172710',
          900: '#0B1308',
        },
        ink: {
          DEFAULT: '#1E2A1E',
          sub:     '#5A6A5A',
          muted:   '#9AAA9A',
          faint:   '#C8DEC8',
        },
      },
    },
  },
  plugins: [
    require('daisyui')
  ],
  daisyui: {
    themes: [
      {
        // ライトモード
        color: {
          "primary":          "#6A9E6A",
          "primary-content":  "#ffffff",
          "secondary":        "#A9C1A9",
          "secondary-content":"#1E2A1E",
          "accent":           "#7BAD7B",
          "accent-content":   "#ffffff",
          "neutral":          "#1E2A1E",
          "neutral-content":  "#F4F8F4",
          "base-100":         "#ffffff",
          "base-200":         "#F4F8F4",
          "base-300":         "#C8D9C8",
          "base-content":     "#1E2A1E",
          "info":             "#3abff8",
          "success":          "#6A9E6A",
          "warning":          "#fbbd23",
          "error":            "#f87272",
        },
        // ダークモード
        "color-dark": {
          "primary":          "#7BAD7B",
          "primary-content":  "#ffffff",
          "secondary":        "#4A7A4A",
          "secondary-content":"#F4F8F4",
          "accent":           "#6A9E6A",
          "accent-content":   "#ffffff",
          "neutral":          "#C8D9C8",
          "neutral-content":  "#1E2A1E",
          "base-100":         "#1E2A1E",
          "base-200":         "#172710",
          "base-300":         "#0B1308",
          "base-content":     "#F4F8F4",
          "info":             "#3abff8",
          "success":          "#7BAD7B",
          "warning":          "#fbbd23",
          "error":            "#f87272",
        },
      },
    ],
    darkTheme: "color-dark",
  },
}
