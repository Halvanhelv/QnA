# QnA

A Stack Overflow-style questions and answers app built on the Hotwire stack: no Node build step, live updates over
WebSockets, rich text, tags, voting, rewards, full text search and a JSON API.

## Features

- **Questions and answers** with rich text bodies (Lexxy / Action Text), file attachments (Active Storage) and links.
- **Tags**: up to 5 per question, popular tags on the index, filter by tag.
- **Sorting and pagination** of the questions list: `newest`, `unanswered`, `top` (by rating), 15 per page.
- **Voting**: upvote or downvote a question or an answer, repeat the same vote to cancel it. Authors cannot vote for their own posts.
- **Best answer**: the question author accepts one answer; it is pinned to the top of the list.
- **Rewards**: a question can offer a reward (name and image); it goes to the author of the accepted answer and shows up on the Rewards page.
- **Comments** on questions and answers.
- **Subscriptions**: the author is subscribed automatically; subscribers get an email for every new answer.
- **Daily digest**: an email with the questions of the last day, sent every day at 9am.
- **Search**: PostgreSQL full text search (`pg_search`) over questions, answers, comments and users, or across everything.
- **Live updates**: new questions, answers and comments appear for everyone without a reload (Turbo Streams over Solid Cable).
- **Auth**: Devise with email confirmation, plus GitHub and Telegram sign-in (OmniAuth). If a provider does not return an email, the app asks for it.
- **Authorization**: CanCanCan, see [Roles](#roles).
- **JSON API v1** secured by Doorkeeper (OAuth 2), see [API](#api).
- **Light and dark theme**: follows the system setting, can be switched manually and is remembered in `localStorage`.
- **Admin tools**: Mission Control for background jobs at `/jobs` (admins only).

## Stack

| Area | Choice |
|---|---|
| Runtime | Ruby 4.0 (see `.ruby-version`), Rails 8.1 |
| Database | PostgreSQL |
| Frontend | Hotwire (Turbo Drive, Frames, Streams, Stimulus), importmap, Propshaft, Slim templates |
| Styling | Tailwind CSS 4 via `tailwindcss-rails`; design tokens live in `app/assets/tailwind/application.css` |
| Rich text | Lexxy (Action Text) |
| Select boxes | Choices.js, wired through a Stimulus controller |
| Background jobs, cache, cable | Solid Queue, Solid Cache, Solid Cable (all backed by PostgreSQL) |
| Auth | Devise, OmniAuth (`omniauth-github`, `omniauth-telegram`), Doorkeeper |
| Authorization | CanCanCan |
| Search | `pg_search` |
| API serialization | Active Model Serializers |
| Pagination | `will_paginate` |
| Files | Active Storage (local disk by default, Google Cloud Storage available) |
| Tests | Minitest with fixtures, Capybara and Selenium for system tests |
| Deploy | Kamal, Docker, Thruster |

## Getting started

Requirements: Ruby from `.ruby-version`, PostgreSQL, libvips (image variants).

```bash
cp config/database.yml.sample config/database.yml
bin/rails db:setup
bin/dev            # Rails server (port 3000) and the Tailwind watcher
```

Open the app at **http://127.0.0.1:3000**, not `localhost`: the GitHub OAuth app redirects to `127.0.0.1`.

In development, emails are opened in the browser by `letter_opener`, so no SMTP is needed. `db/seeds.rb` is empty:
register through the UI and confirm the email in the letter that opens. To get an admin, set the flag in the console:

```bash
bin/rails runner 'User.find_by(email: "you@example.com").update!(admin: true)'
```

## Credentials and integrations

Every secret is read from `ENV` first and falls back to Rails credentials under the current environment key.
Credentials are encrypted in `config/credentials.yml.enc`; the key is `config/master.key` (git-ignored, keep a copy in a
password manager). Edit with `bin/rails credentials:edit`.

| Integration | ENV | Credentials keys |
|---|---|---|
| GitHub OAuth | `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET` | `<env>.github.client_id`, `<env>.github.client_secret` |
| Telegram Login | `TELEGRAM_BOT_NICKNAME`, `TELEGRAM_BOT_TOKEN` | `<env>.telegram.BOT_NICKNAME`, `<env>.telegram.BOT_TOKEN` |
| Gmail SMTP (production mail) | `GMAIL_EMAIL`, `GMAIL_PASSWORD` (an app password) | `production.gmail.email`, `production.gmail.password` |
| Google Cloud Storage (optional) | `ACTIVE_STORAGE_SERVICE=google` | `google_storage` (service account JSON) |

Example `development` credentials:

```yaml
development:
  github:
    client_id: ...
    client_secret: ...
  telegram:
    BOT_NICKNAME: your_bot
    BOT_TOKEN: "123456:ABC..."
  gmail:
    email: you@gmail.com
    password: app password
```

### GitHub

Create an OAuth app at GitHub → Settings → Developer settings. For development use `http://127.0.0.1:3000/` as
the homepage and redirect URI. The callback is `/users/auth/github/callback`.

### Telegram: limitation in development

The Telegram Login Widget does **not** work on `http://127.0.0.1:3000` or `http://localhost:3000`:

- BotFather `/setdomain` rejects `localhost` (a domain with a dot is required), so the widget answers `Bot domain invalid`.
- Telegram serves the widget iframe with `frame-ancestors http://127.0.0.1` without a port, so the browser blocks it on
  any port except 80 and 443 and the button never renders.

To test Telegram sign-in you need a public HTTPS domain, for example an ngrok tunnel: run `ngrok http 3000`, set the
tunnel host with `/setdomain` in @BotFather, and add the host to `config.hosts` in `config/environments/development.rb`.
GitHub sign-in is not affected.

## Roles

| Role | Can |
|---|---|
| Guest | Read questions, answers, comments and search. Cannot see the Rewards page |
| User | Create questions, answers, comments, links and subscriptions; edit and delete their own; vote on posts of other users; accept an answer to their own question; delete their own attachments |
| Admin | Everything, including `/jobs` |

Rules live in `app/models/ability.rb`. Every request is authorized on the server.

## How live updates work

Broadcasts are rendered once and sent to every subscriber, so partials used in broadcasts
(`questions/_question`, `answers/_answer`, `comments/_comment`) never depend on `current_user`. User-specific controls
are rendered hidden and revealed by the `visibility` Stimulus controller using the `current-user-id` meta tag. This is
a UX convenience only.

Votes, flash messages and form errors are returned as Turbo Stream responses. Stimulus controllers in
`app/javascript/controllers` cover the theme switch, flash messages, nested link forms, form reset, Cmd/Ctrl+Enter
submit, syntax highlighting, the vote rail and Choices.js selects.

## API

Base path `/api/v1`, JSON. Authenticate with a Doorkeeper OAuth 2 access token (`Authorization: Bearer <token>`).
Register a client application at `/oauth/applications`.

| Method and path | Description |
|---|---|
| `GET /profiles` | All users except the token owner |
| `GET /profiles/me` | The token owner |
| `GET /questions`, `GET /questions/:id` | List and show questions |
| `POST /questions`, `PATCH /questions/:id`, `DELETE /questions/:id` | Manage questions (subject to CanCanCan) |
| `GET /questions/:question_id/answers` | Answers of a question |
| `GET /answers/:id` | Show an answer |
| `POST /questions/:question_id/answers`, `PATCH /answers/:id`, `DELETE /answers/:id` | Manage answers |

## Background jobs

Solid Queue runs inside Puma in production (`SOLID_QUEUE_IN_PUMA`). Recurring tasks are in `config/recurring.yml`:

- `DailyDigestJob`: daily at 9am, sends the digest to every user if there are new questions.
- clean-up of finished jobs, hourly.

`NewAnswerNotificationJob` runs after an answer is created. Watch the queues in Mission Control at `/jobs`.

## Tests and checks

```bash
bin/rails test           # models, controllers, jobs, mailers, services, integration
bin/rails test:system    # Turbo and Stimulus behaviour in headless Chrome
bin/rubocop
bin/brakeman
bin/bundler-audit
bin/ci                   # the full local pipeline (see config/ci.rb)
```

GitHub Actions (`.github/workflows/ci.yml`) runs Brakeman, bundler-audit, importmap audit, RuboCop, the test suite and the
system tests.

## Deployment

Deployed with Kamal to a single host (`config/deploy.yml`): one web role with Solid Queue inside Puma, and a PostgreSQL
accessory that hosts the primary, cache, queue and cable databases (`db/production_setup.sql` creates the extra ones).
Uploaded files live in the `qna_storage` volume.

```bash
bin/kamal setup    # first time
bin/kamal deploy
```

Secrets are listed in `.kamal/secrets` and passed as ENV: `RAILS_MASTER_KEY` (read from `config/master.key`),
`QNA_DATABASE_PASSWORD`, `POSTGRES_PASSWORD`, `GMAIL_EMAIL`, `GMAIL_PASSWORD`, `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`,
`TELEGRAM_BOT_NICKNAME`, `TELEGRAM_BOT_TOKEN`. The GitHub OAuth app and the Telegram bot domain must point to the
production host (`APP_HOST`); the development OAuth app only knows `127.0.0.1`.
