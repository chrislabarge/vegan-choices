require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#omni_authenticated?' do
    let(:user) { FactoryGirl.create(:user) }

    it 'returns false' do
      expected = false
      actual = user.omni_authenticated?

      expect(actual).to eq expected
    end

    it 'returns true' do
      user.uid = "some string"
      user.provider = "facebook"

      user.save
      user.reload

      expected = true
      actual = user.omni_authenticated?

      expect(actual).to eq expected
    end
  end
end
