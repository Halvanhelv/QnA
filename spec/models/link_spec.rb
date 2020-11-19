# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context 'methods' do
    describe 'gist?' do
      let!(:gist_link) { create(:link, url: 'https://gist.github.com/SynthesisOne/6b6c203392c75d2dd2e57c5fd4ac411d') }
      let!(:link) { create(:link, url: 'https://google.com') }

      it { expect(gist_link.gist?).to be_truthy }
      it { expect(link.gist?).to be_falsey }
    end
  end
end
