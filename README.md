# ZSSN (Zombie Survival Social Network) API

This is a Rails API project.

## Requirements

- Ruby 3.3.0
- Rails 7.1.3

## Dependencies

- [Blueprinter](https://github.com/procore/blueprinter) - Gem for generating JSON responses.
- [Rswag](https://github.com/rswag/rswag) - Gem for API documentation and testing with Swagger.
- [RSpec Rails](https://github.com/rspec/rspec-rails) - Gem for testing the application.
- [Factory Bot Rails](https://github.com/thoughtbot/factory_bot_rails) - Gem for defining and using factories in tests.
- [Faker](https://github.com/faker-ruby/faker) - Gem for generating fake data in your tests.
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) - Gem for writing RSpec tests for the application.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/beatrizChagas/zombie-api.git
cd zombie-api
```

2. Install dependencies

```bash
bundle install
```

3. Set up the database

```bash
rails db:create
rails db:migrate
```

4. Start the server

```bash
rails server
```

## Usage

Access API endpoints at `http://localhost:3000`

## Tests

Run the RSpec tests:

```bash
bundle exec rspec
```

## Docs
All routes are documented and accessible, at: `http://localhost:3000/api-docs/index.html`