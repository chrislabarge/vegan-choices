require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:comments).inverse_of(:user) }
  it { should have_many(:reports).inverse_of(:user) }
  it { should have_many(:report_comments).through(:comments) }

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

  describe '#negative_reports' do
    let(:report_comment) { FactoryGirl.create(:report_comment) }
    let(:user) { report_comment.comment.user }

    it 'returns an array of negative reports' do
      expected = [report_comment.report]
      actual = user.negative_reports

      expect(actual).to eq expected
    end
  end
end
