require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:locations).inverse_of(:user) }
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
  it { should have_many(:comments_berried).through(:content_berries).source(:comment) }
  it { should have_many(:items_berried).through(:content_berries).source(:item) }
  it { should have_many(:comment_berries).through(:comments).source(:content_berries) }
  it { should have_many(:restaurant_berries).through(:restaurants).source(:content_berries) }
  it { should have_many(:item_berries).through(:items).source(:content_berries) }
  it { should have_many(:restaurant_berries).through(:restaurants).source(:content_berries) }
  it { should have_many(:items).inverse_of(:user) }
  it { should have_many(:item_photos).inverse_of(:user) }
  it { should have_many(:restaurants).inverse_of(:user) }
  it { should validate_uniqueness_of(:name) }

  describe '#omni_authenticated?' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns false' do
      expected = false
      actual = user.omni_authenticated?

      expect(actual).to eq expected
    end

    it 'returns true' do
      user.uid = "some string"
      user.provider = "twitter"

      user.save
      user.reload

      expected = true
      actual = user.omni_authenticated?

      expect(actual).to eq expected
    end
  end

  describe '#negative_reports' do
    let(:report_comment) { FactoryBot.create(:report_comment) }
    let(:user) { report_comment.comment.user }
    let(:restaurant) { FactoryBot.create(:restaurant, user: user) }
    let(:item) { FactoryBot.create(:item, user: user) }
    let(:report_restaurant) { FactoryBot.create(:report_restaurant, restaurant: restaurant) }
    let(:report_item) { FactoryBot.create(:report_item, item: item) }

    before(:each) do
      report_restaurant
      report_item
    end

    it 'returns an array of negative reports' do
      reports = user.negative_reports

      expect(reports).to include report_comment.report
      expect(reports).to include report_restaurant.report
      expect(reports).to include report_item.report
    end
  end

  describe '#followers' do
    let(:user) { FactoryBot.create(:user) }
    let(:follower) { FactoryBot.create(:user) }

    it 'returns an array of negative reports' do
      FactoryBot.create(:favorite, user: follower, profile: user)

      followers = user.followers

      expect(followers).to include follower
    end
  end

  describe 'when account gets deleted' do
    let(:user) { FactoryBot.create(:user) }
    let(:item) { FactoryBot.create(:item, user: user) }

    it 'still has content that does not get deleted' do
      item

      user.destroy

      item.reload

      expect(item.persisted?).to eq true
      expect(user.persisted?).to eq false
    end
  end
end

