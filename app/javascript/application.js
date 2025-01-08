// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"


import { HighlightJS } from "highlight.js"

HighlightJS.configure({ languages: ["css", "html", "javascript", "python", "ruby"] })

document.addEventListener("turbo:load", (event) => {
  document.querySelectorAll('pre').forEach((block) => {
    HighlightJS.highlightElement(block)
  })
})

// Make it simpler to add code blocks in Trix

addEventListener("trix-initialize", event => {
  const { toolbarElement } = event.target
  const bulletButton = toolbarElement.querySelector("[data-trix-attribute=code]")
  bulletButton.setAttribute("data-trix-key", "u")
})
