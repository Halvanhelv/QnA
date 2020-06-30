# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it { should  have_db_column(:question_id) }
  it { should  have_db_column(:body) }
  it { should  have_db_index(:question_id) }
end
