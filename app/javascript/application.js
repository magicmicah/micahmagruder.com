// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"


import { HighlightJS } from "highlight.js"

HighlightJS.configure({ languages: ["ruby", "python", "javascript"] })

document.addEventListener("turbo:load", (event) => {
  document.querySelectorAll('pre').forEach((block) => {
    HighlightJS.highlightElement(block)
    console.log('highlighted')
    console.log(block)
  })
})