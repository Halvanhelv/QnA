# frozen_string_literal: true

module Question::Broadcasts
  extend ActiveSupport::Concern

  included do
    after_create_commit :broadcast_to_index
    after_update_commit :broadcast_changes
    after_destroy_commit :broadcast_removal
  end

  def broadcast_answers
    broadcast_replace_to self, target: 'answers', partial: 'answers/list', locals: { question: self }
  end

  private

  def broadcast_to_index
    broadcast_prepend_to 'questions', target: 'questions', partial: 'questions/list_item', locals: { question: self }
  end

  def broadcast_changes
    broadcast_replace_to 'questions', target: dom_id_for(:list_item), partial: 'questions/list_item',
                                      locals: { question: self }
    broadcast_replace_to self, target: self, partial: 'questions/question', locals: { question: self }
  end

  def broadcast_removal
    broadcast_remove_to 'questions', target: dom_id_for(:list_item)
    broadcast_remove_to self
  end

  def dom_id_for(prefix)
    ActionView::RecordIdentifier.dom_id(self, prefix)
  end
end
