# XPTracker

A Ruby on Rails web application, designed to run inside a [Dev Container](https://code.visualstudio.com/docs/devcontainers/containers/) for consistent development environments across systems.

## 🚀 Getting Started

### Prerequisites

- [Docker](https://www.docker.com/)
- [Visual Studio Code](https://code.visualstudio.com/) with the **Dev Containers** extension installed

## 🛠️ Running the Project

1. **Clone the repository**

   ```bash
   git clone https://github.com/clsechi/xp-tracker.git
   cd xp-tracker
    ```

2. **Open the project in VS Code**

   * Run `code .`
   * VS Code should prompt you to "Reopen in Container" — click it.
   * If not prompted: Open Command Palette (⇧⌘P / Ctrl+Shift+P) → “Dev Containers: Reopen in Container”

3. **Once inside the container:**

   * Install gems:

     ```bash
     bundle install
     ```

   * Set up the database:

     ```bash
     bin/rails db:setup
     ```

   * Start the server:

     ```bash
     bin/dev
     ```

   * The app will be accessible at [http://localhost:3000](http://localhost:3000)

## ✅ Running Tests

1. **Run the full test suite**

   ```bash
   bundle exec rspec
   ```

## Notes

* It is assumed that subscription recalculations occur daily at 00:00 UTC
* It is assumed that if there is a problem retrieving the subscription status, the user should still be allowed to access the app
* Use [counter_cache](https://thoughtbot.com/blog/what-is-counter-cache) to avoid performing count queries when retrieving the user's total games played.
* Use JWT with a 24-hour expiration time to authenticate user requests.


## 🌱 Future Improvements

* Implement a more robust authentication solution, such as Devise with devise-jwt or devise-token-auth
* Add a feature to invalidate JWT tokens
* Receive events from BillingService when a change on a subscription occurs
* Add Redis or SolidCache for caching on production
* Set up CI/CD pipeline using GitHub Actions

## 📦 Common Commands

| Task          | Command                     |
| ------------- | --------------------------- |
| Start the app | `bin/dev`                   |
| Rails console | `bin/rails console`         |
| DB Migrate    | `bin/rails db:migrate`      |
| Run tests     | `rspec`                     |
| Rubocop       | `bundle exec rubocop`       |
