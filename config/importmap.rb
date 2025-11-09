# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Pin custom JavaScript modules
pin "login", to: "login.js"
pin "user", to: "user.js"
pin "main", to: "main.js"
pin "concerns/util", to: "concerns/util.js"
