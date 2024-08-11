// In engines/bravura_template_base/tailwind.preset.js
module.exports = {
    theme: {
      extend: {
        colors: {
          primary: {
            50: 'var(--primary-50)',
            // ... other shades
            900: 'var(--primary-900)',
          },
          // ... other color definitions
        },
        // ... other theme extensions
      },
    },
    plugins: [
      require('@tailwindcss/typography'),
      // ... other plugins
    ],
  }