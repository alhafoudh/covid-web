const colors = require('tailwindcss/colors');

module.exports = {
  purge: [
    './app/**/*.rb',
    './app/**/*.html.erb',
    './app/**/*.*.html.erb',
    './app/**/*.js',
    './app/**/*.ts',
    './app/**/*.scss',
    './config/locales/*.yml'
  ],
  corePlugins: {
    backgroundOpacity: false,
    borderOpacity: false,
    textOpacity: false,
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    fontFamily: {
      sans: ['Roboto', 'sans-serif'],
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: {
        dark: '#838383',
        DEFAULT: '#aaaaaa',
        light: '#f0f0f0',
      },
      indigo: colors.indigo,
      red: {
        dark: '#991b1b',
        DEFAULT: '#e00000',
        light: '#fff0f0',
      },
      yellow: {
        dark: colors.amber[800],
        DEFAULT: colors.amber[500],
        light: colors.amber[100],
      },
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
    fontSize: {
      'xs': '.75rem',
      'sm': '.875rem',
      'tiny': '.875rem',
      'base': '1rem',
      'lg': '1.125rem',
      'xl': '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem',
      '4xl': ['2.375rem', {lineHeight: '1.31em'}],
      '5xl': '3rem',
      '6xl': '4rem',
      '7xl': '5rem',
    },
    extend: {
      spacing: {
        30: '7.5rem'
      },
      typography: {
        DEFAULT: {
          css: {
            h1: {
              fontWeight: 300,
            },
            h2: {
              fontWeight: 300,
            },
            h3: {
              fontWeight: 300,
            },
            h4: {
              fontWeight: 300,
            },
          }
        }
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

