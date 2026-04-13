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
      // title2: ['"Libre Baskerville"', 'serif'],
      title:  ['"Playfair Display"',   'serif'], //1
      english: ['"DM Serif Display"', 'serif'], //2
      cormorant: ['"Cormorant Garamond"', 'serif'], //3
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
       // --- ヒーロー背景・深い緑 系（今回追加）---
        // トップページのヒーロー背景やテキストに使う
        forest: {
          50:  '#D4EEE3',  
          100: '#B8DDD0',
          200: '#8FCAB8',
          300: '#5DCAA5',  
          400: '#2C5F45',  
          500: '#1D9E75',  
          600: '#0F6E56',  
          700: '#085041',
          800: '#1a3d2e',  
          900: '#0D2018',
        },
        // --- クリーム系（ページ背景）（今回追加）---
        cream: {
          50:  '#FAFAF7',  
          100: '#F5F2E8', 
          200: '#EDE8D8',
          300: '#D3D1C7', 
          400: '#B4B2A9', 
          500: '#888780',  
        },
        // --- ink（本文テキスト）---
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
          "primary":          "#1D9E75",
          "primary-content":   "#ffffff",
          "secondary":         "#A9C1A9",
          "secondary-content": "#1E2A1E",
          "accent":            "#7BAD7B",
          "accent-content":    "#ffffff",
          "neutral":           "#1E2A1E",
          "neutral-content":   "#F4F8F4",
          "base-100":          "#ffffff",
          "base-200":          "#FAFAF7",
          "base-300":          "#D3D1C7",
          "base-content":      "#1E2A1E",
          "info":              "#3abff8",
          "success":           "#1D9E75",
          "warning":           "#fbbd23",
          "error":             "#f87272",
        },
        // ダークモード
          "color-dark": {
          "primary":           "#1D9E75",
          "primary-content":   "#ffffff",
          "secondary":         "#4A7A4A",
          "secondary-content": "#F4F8F4",
          "accent":            "#6A9E6A",
          "accent-content":    "#ffffff",
          "neutral":           "#C8D9C8",
          "neutral-content":   "#1E2A1E",
          "base-100":          "#1E2A1E",
          "base-200":          "#172710",
          "base-300":          "#0B1308",
          "base-content":      "#F4F8F4",
          "info":              "#3abff8",
          "success":           "#7BAD7B",
          "warning":           "#fbbd23",
          "error":             "#f87272",
        },
      },
    ],
    darkTheme: "color-dark",
  },
}
