# frozen_string_literal: true

# Building blocks for HTML emails. Mail clients ignore most external CSS, so every style is inline;
# the dark scheme is handled by the class hooks in the layout's <style> block.
module MailerHelper
  INK = '#141b2d'
  MUTED = '#5b6579'
  LINE = '#dde2ec'
  BRAND = '#3347ff'
  SURFACE = '#ffffff'
  CANVAS = '#f2f4f8'
  FONT_DISPLAY = "'Bricolage Grotesque', 'Segoe UI', Helvetica, Arial, sans-serif"
  FONT_BODY = "'Figtree', 'Segoe UI', Helvetica, Arial, sans-serif"

  def mail_heading(text)
    content_tag(:h1, text, class: 'ink', style: "margin:0 0 16px;font-family:#{FONT_DISPLAY};font-size:26px;line-height:1.25;font-weight:700;letter-spacing:-0.02em;color:#{INK};")
  end

  def mail_paragraph(text = nil, muted: false, &block)
    color = muted ? MUTED : INK
    content_tag(:p, text || capture(&block), class: (muted ? 'muted' : 'ink'),
                                             style: "margin:0 0 16px;font-size:16px;line-height:1.6;color:#{color};")
  end

  # Bulletproof button: a table cell carries the background so Outlook renders it too.
  def mail_button(label, url)
    link = link_to(label, url, class: 'btn-text',
                               style: "display:inline-block;padding:12px 22px;font-family:#{FONT_BODY};font-size:15px;font-weight:600;line-height:1;color:#ffffff;text-decoration:none;")
    tag.table(role: 'presentation', cellspacing: 0, cellpadding: 0, border: 0, style: 'margin:8px 0 24px;') do
      tag.tr { tag.td(link, class: 'btn', bgcolor: BRAND, style: "background:#{BRAND};border-radius:6px;") }
    end
  end

  # Excerpt of a user's text (an answer) set apart with a left rule
  def mail_quote(text, attribution: nil)
    body = content_tag(:p, text, class: 'ink', style: "margin:0;font-size:15px;line-height:1.6;color:#{INK};white-space:pre-line;")
    who = attribution && content_tag(:p, attribution, class: 'muted', style: "margin:8px 0 0;font-size:13px;color:#{MUTED};")
    content_tag(:div, safe_join([body, who].compact), class: 'quote',
                                                       style: "margin:0 0 20px;padding:14px 16px;border-left:3px solid #{BRAND};background:#{CANVAS};border-radius:0 6px 6px 0;")
  end

  # The raw link for clients that block buttons
  def mail_fallback_link(url)
    content_tag(:p, class: 'muted', style: "margin:0 0 20px;font-size:13px;line-height:1.5;color:#{MUTED};word-break:break-all;") do
      safe_join(['Button not working? Copy this address into your browser:', tag.br, link_to(url, url, class: 'link', style: "color:#{BRAND};")])
    end
  end
end
