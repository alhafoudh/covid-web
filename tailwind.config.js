const colors = require('tailwindcss/colors');

module.exports = {
  purge: [
    './app/**/*.rb',
    './app/**/*.html.erb',
    './app/**/*.js',
    './app/**/*.ts',
    './app/**/*.scss',
    './config/locales/*.yml'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    fontFamily: {
      sans: ['Work Sans', 'sans-serif'],
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.trueGray,
      indigo: colors.indigo,
      red: colors.rose,
      yellow: colors.amber,
      blue: colors.blue,
      green: colors.green,
      orange: colors.orange,
    },
    extend: {
      spacing: {
        30: '7.5rem'
      }
    },
  },
  variants: {
    extend: {
      transform: ['hover', 'focus'],
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
}

