require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:comments).inverse_of(:user) }
  it { should have_many(:reports).inverse_of(:user) }
  it { should have_many(:report_comments).through(:comments) }
  it { should have_many(:favorites).inverse_of(:user).dependent(:destroy) }
  it { should have_many(:favorite_restaurants).through(:favorites).source(:restaurant) }
  it { should have_many(:favorite_items).through(:favorites).source(:item) }
  it { should have_many(:favorite_users).through(:favorites).source(:profile) }
  it { should have_many(:following_favorites).class_name('Favorite').with_foreign_key('profile_id').source(:user) }
  it { should have_many(:followers).through(:following_favorites).source(:user) }
  it { should have_many(:content_berries).inverse_of(:user) }
  it { should have_many(:items).inverse_of(:user) }
  it { should have_many(:restaurants).inverse_of(:user) }

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

  describe '#followers' do
    let(:user) { FactoryGirl.create(:user) }
    let(:follower) { FactoryGirl.create(:user) }

    it 'returns an array of negative reports' do
      FactoryGirl.create(:favorite, user: follower, profile: user)

      followers = user.followers

      expect(followers).to include follower
    end
  end
end

