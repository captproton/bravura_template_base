// In engines/bravura_template_base/tailwind.config.js
module.exports = {
    presets: [require('./tailwind.preset.js')],
    content: [
      './app/**/*.{erb,html,rb}',
      '../bravura_template_prime/**/*.{erb,html,rb}',
      // Add paths for future templates here
    ],
  }