# Этап 1: апгрейд платформы (Ruby + Rails)

## Контекст

QnA: Rails 6.0.6, Ruby 2.7.3 (`.ruby-version`), PostgreSQL, RSpec, Sidekiq, Sphinx, Devise, Doorkeeper, CanCanCan.
Это первый из 5 этапов миграции на Hotwire-стек (см. ниже). Этап 1 не трогает фронтенд-архитектуру, только платформу.

## Roadmap (для контекста)

1. **Платформа**: Ruby, Rails (этот документ)
2. Ассеты: webpacker → Propshaft + importmap, убрать jQuery/Turbolinks/ujs/cocoon/Handlebars
3. Hotwire: Turbo Drive/Frames/Streams + Stimulus вместо jQuery + ActionCable + Handlebars
4. Solid-стек и деплой: Solid Queue/Cache/Cable, Kamal, pg_search вместо Sphinx, убрать mysql2
5. Тесты: RSpec → Minitest + fixtures

Решения пользователя: JSON API v1 + Doorkeeper остаются; полная модернизация; Minitest в конце.

## Цель

Приложение работает на **Ruby 4.0.x** (локально 4.0.5) и **Rails 8.1.x**, все существующие RSpec-тесты зелёные, без изменений поведения.

## Подход

Ruby и Rails обновляются **раздельно** (рекомендация сообщества: не совмещать прыжки).

1. **Baseline.** Поднять приложение на Ruby 3.2.x (совместим с Rails 6.0 только частично; при невозможности использовать 2.7.5, уже установлен) и зафиксировать состояние `rspec`: список падающих тестов до начала работ. Падения baseline не считаются регрессиями.
2. **Rails по одному минору:** 6.0 → 6.1 → 7.0 → 7.1 → 7.2 → 8.0 → 8.1. На каждом шаге: `bundle update rails` + связанные гемы, `rails app:update`, исправление deprecations, зелёный `rspec`, отдельный коммит.
3. **Ruby** поднимается до минимально нужного на каждом шаге (Rails 7.0 → 3.1+, 7.2 → 3.2+, 8.1 → 3.2+), финально до 4.0.x, когда Rails уже 8.1 и всё зелёное.
4. **Гемы:** для каждого проверить совместимость; заброшенные заменить или удалить:
   - `mini_racer`, `handlebars-source`, `spring*`, `byebug`, `webdrivers`: удалить/заменить (`debug`, Selenium Manager)
   - `mysql2`: удалить, если не используется (проверить `database.yml`/thinking-sphinx)
   - `unicorn`, `capistrano-*`: оставить до этапа 4, только совместимость
   - `active_model_serializers`: если несовместим с Rails 8.1, заменить на jbuilder для API v1 с сохранением формата ответов
   - `thinking-sphinx`, `doorkeeper`, `devise`, `omniauth-*`, `cancancan`, `decent_exposure`, `will_paginate`, `cocoon`: обновить до совместимых версий
5. **Конфиг Rails:** `config.load_defaults` повышается ступенчато вместе с апгрейдом; переход на новые defaults только после зелёных тестов на шаге. Устаревший `secrets`/credentials, `config.autoloader` → Zeitwerk, `Rails.application.config.action_dispatch.cookies_serializer` и т.п.
6. **Webpacker остаётся** на этом этапе (его уберёт этап 2). Если он блокирует Rails 7+, временно перейти на `jsbundling-rails` не нужно; вместо этого пропустить прямо к этапу 2 для ассетов на шагах 7.x (порядок этапов 1 и 2 можно чередовать).
7. **CI** (`.github/workflows`): Ruby из `.ruby-version`, Postgres 16+, проверка на Node не нужна после этапа 2.

## Критерии готовности

- `.ruby-version` = 4.0.x, `Gemfile.lock` на `rails 8.1.x`
- `bundle exec rspec` проходит не хуже baseline
- `bin/rails zeitwerk:check` чист
- Нет deprecation warnings при прогоне тестов
- Приложение запускается (`bin/rails s`), главная, вопросы, ответы, логин, API v1 открываются

## Риски

| Риск | Смягчение |
|---|---|
| Webpacker блокирует Rails 7+ | см. п.6, при необходимости слить с этапом 2 |
| Несовместимость AMS/thinking-sphinx с Rails 8.1 | замена на jbuilder / форк / откладывание Sphinx до этапа 4 |
| Ruby 4.0: вынесенные stdlib-гемы (`ostruct`, `bigdecimal` и др.) | добавить в Gemfile |
| Нет `database.yml` в репозитории | сгенерировать из окружения/CI на baseline-шаге |
| Baseline-тесты уже красные (Sphinx, selenium) | зафиксировать список, не чинить вне scope |

## Вне scope

Изменения фронтенда, замена очередей/кэша/деплоя/поиска, миграция на Minitest.
