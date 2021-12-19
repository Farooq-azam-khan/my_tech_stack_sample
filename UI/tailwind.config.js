module.exports = {
  mode: 'jit', // for version 2, waiting for stable v3
  purge: [
    './src/**/*.html', 
    './src/**/*.elm'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
