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
  corePlugins: {
    backgroundOpacity: false,
    textOpacity: false,
  },
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
      red: {
        DEFAULT: '#e00000',
        light: '#fff0f0',
      },
      yellow: colors.amber,
      blue: {
        dark: "#266eb6",
        DEFAULT: "#368ede",
        light: "#ddefff",
      },
      green: {
        dark: '#065F46',
        DEFAULT: '#059669',
        light: '#d2f5df',
      },
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

