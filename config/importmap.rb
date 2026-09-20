# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'choices.js' # @11.2.4

# Lexxy rich text editor (Action Text)
pin 'lexxy', to: 'lexxy.js'
pin '@rails/activestorage', to: 'activestorage.esm.js'
