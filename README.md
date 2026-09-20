# QnA

Questions and answers app built on the Hotwire stack.

- **Ruby 4.0**, **Rails 8.1**, PostgreSQL
- **Hotwire**: Turbo Drive/Frames/Streams (live answers, comments, questions list) and Stimulus, served through importmap and Propshaft, no Node build step
- **Solid stack**: Solid Queue (jobs and recurring digest), Solid Cache, Solid Cable, all backed by PostgreSQL
- **Search**: PostgreSQL full text search via `pg_search`
- Auth: Devise + OmniAuth (GitHub, Telegram), CanCanCan; JSON API v1 secured by Doorkeeper
- Deployment: Kamal (`config/deploy.yml`), Docker
- Tests: Minitest with fixtures, Capybara system tests

## Setup

```bash
cp config/database.yml.sample config/database.yml
bin/rails db:setup
bin/dev            # or bin/rails server
```

OAuth keys and the mail account come from ENV (`GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`,
`TELEGRAM_BOT_NICKNAME`, `GMAIL_EMAIL`, `GMAIL_PASSWORD`) or from Rails credentials
(`bin/rails credentials:edit`, keys `<env>.github`, `<env>.telegram`, `<env>.gmail`).

## Tests and checks

```bash
bin/rails test           # unit and integration tests
bin/rails test:system    # Turbo/Stimulus behaviour in headless Chrome
bin/rubocop
bin/brakeman
```

## How live updates work

Broadcasts are rendered once and sent to every subscriber, so partials used in broadcasts
(`questions/_question`, `answers/_answer`, `comments/_comment`) never depend on `current_user`.
User-specific controls are rendered hidden and revealed by the `visibility` Stimulus controller
using the `current-user-id` meta tag. This is a UX convenience only; every request is authorized on the server.

## Deployment

```bash
bin/kamal setup    # first time
bin/kamal deploy
```

Secrets are listed in `.kamal/secrets`. The production database hosts the primary, cache, queue and cable
databases (`db/production_setup.sql` creates the extra ones).
