# frozen_string_literal: true

module ApplicationHelper
  AVATAR_TONES = 6

  ICONS = {
    chevron_up: 'm4.5 15.75 7.5-7.5 7.5 7.5',
    chevron_down: 'm19.5 8.25-7.5 7.5-7.5-7.5',
    check: 'm4.5 12.75 6 6 9-13.5',
    link: 'M13.19 8.688a4.5 4.5 0 0 1 1.242 7.244l-4.5 4.5a4.5 4.5 0 0 1-6.364-6.364l1.757-1.757m13.35-.622 1.757-1.757a4.5 4.5 0 0 0-6.364-6.364l-4.5 4.5a4.5 4.5 0 0 0 1.242 7.244',
    paperclip: 'm18.375 12.739-7.693 7.693a4.5 4.5 0 0 1-6.364-6.364l10.94-10.94A3 3 0 1 1 19.5 7.372L8.552 18.32m.009-.01-.01.01m5.699-9.941-7.81 7.81a1.5 1.5 0 0 0 2.112 2.13',
    search: 'm21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z',
    plus: 'M12 4.5v15m7.5-7.5h-15',
    x: 'M6 18 18 6M6 6l12 12',
    sun: 'M12 3v2.25m6.364.386-1.591 1.591M21 12h-2.25m-.386 6.364-1.591-1.591M12 18.75V21m-4.773-4.227-1.591 1.591M5.25 12H3m4.227-4.773L5.636 5.636M15.75 12a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0Z',
    moon: 'M21.752 15.002A9.72 9.72 0 0 1 18 15.75c-5.385 0-9.75-4.365-9.75-9.75 0-1.33.266-2.597.748-3.752A9.753 9.753 0 0 0 3 11.25C3 16.635 7.365 21 12.75 21a9.753 9.753 0 0 0 9.002-5.998Z',
    trophy: 'M16.5 18.75h-9m9 0a3 3 0 0 1 3 3h-15a3 3 0 0 1 3-3m9 0v-3.375c0-.621-.503-1.125-1.125-1.125h-.871M7.5 18.75v-3.375c0-.621.504-1.125 1.125-1.125h.872m5.007 0H9.497m5.007 0a7.454 7.454 0 0 1-.982-3.172M9.497 14.25a7.454 7.454 0 0 0 .981-3.172M5.25 4.236c-.982.143-1.954.317-2.916.52A6.003 6.003 0 0 0 7.73 9.728M5.25 4.236V4.5c0 2.108.966 3.99 2.48 5.228M5.25 4.236V2.721C7.456 2.41 9.71 2.25 12 2.25c2.291 0 4.545.16 6.75.47v1.516M7.73 9.728a6.726 6.726 0 0 0 2.748 1.35m8.272-6.842V4.5c0 2.108-.966 3.99-2.48 5.228m2.48-5.492a46.32 46.32 0 0 1 2.916.52 6.003 6.003 0 0 1-5.395 4.972m0 0a6.726 6.726 0 0 1-2.749 1.35m0 0a6.772 6.772 0 0 1-3.044 0',
    bell: 'M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0'
  }.freeze

  # Outline icon, decorative unless the caller adds a label around it.
  def icon(name, css = 'size-4')
    tag.svg(tag.path(d: ICONS.fetch(name), 'stroke-linecap': 'round', 'stroke-linejoin': 'round'),
            class: css, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 1.75,
            'aria-hidden': true)
  end

  # Initial in a tinted circle, tone picked by user id so a person keeps their colour.
  def avatar(user, size: 'size-7 text-xs')
    tone = user.id % AVATAR_TONES
    tag.span(user.email.first.upcase, 'aria-hidden': true,
                                      class: "avatar avatar-#{tone} inline-flex #{size} shrink-0 items-center justify-center rounded-full font-semibold")
  end

  def ago(time)
    "#{time_ago_in_words(time)} ago"
  end

  # Author avatar, address and relative time on one line.
  def byline(user, time, verb: 'asked')
    tag.span(class: 'inline-flex items-center gap-2 text-sm text-muted') do
      safe_join([avatar(user), tag.span(user.email, class: 'font-medium text-ink'), tag.span("#{verb} #{ago(time)}")], ' ')
    end
  end
end
