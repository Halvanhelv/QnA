# frozen_string_literal: true

# Question and answer bodies become Action Text rich text (edited with Lexxy).
# Existing plain text is wrapped into paragraphs so nothing is lost.
class MoveBodiesToActionText < ActiveRecord::Migration[8.1]
  TABLES = { 'Question' => :questions, 'Answer' => :answers }.freeze

  def up
    TABLES.each do |type, table|
      select_rows("SELECT id, body FROM #{table}").each do |id, body|
        html = ApplicationController.helpers.simple_format(ERB::Util.html_escape(body.to_s))
        execute <<~SQL.squish
          INSERT INTO action_text_rich_texts (name, body, record_type, record_id, created_at, updated_at)
          VALUES ('body', #{quote(html)}, #{quote(type)}, #{id}, NOW(), NOW())
        SQL
      end

      remove_column table, :body
    end
  end

  def down
    TABLES.each do |type, table|
      add_column table, :body, :text

      select_rows("SELECT record_id, body FROM action_text_rich_texts WHERE record_type = #{quote(type)} AND name = 'body'").each do |id, html|
        text = ActionText::Content.new(html).to_plain_text
        execute "UPDATE #{table} SET body = #{quote(text)} WHERE id = #{id}"
      end

      change_column_null table, :body, false, ''
      execute "DELETE FROM action_text_rich_texts WHERE record_type = #{quote(type)} AND name = 'body'"
    end
  end
end
