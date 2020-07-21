require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user).optional }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:img) }

  it { should have_db_column(:question_id) }
  it { should have_db_column(:user_id) }

  it { expect(Reward.new.img).to be_an_instance_of(ActiveStorage::Attached::One) }
end
