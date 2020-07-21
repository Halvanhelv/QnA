require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context 'methods' do
    describe 'gist?' do
      let!(:gist_link) { create(:link, url: 'https://gist.github.com/SynthesisOne/999ecc10ac745e4f7a3a00ff5b038767') }
      let!(:link) { create(:link, url: 'https://google.com') }

      it { expect(gist_link.gist?).to be_truthy }
      it { expect(link.gist?).to be_falsey }
    end
  end
end
