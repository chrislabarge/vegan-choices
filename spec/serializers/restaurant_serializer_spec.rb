require 'rails_helper'

describe 'RestaurantSerializer' do
  let(:restaurant) { FactoryBot.create(:restaurant) }
  subject { RestaurantSerializer.new(restaurant) }

  it 'includes the expected attributes' do
    expect(subject.attributes.keys)
      .to contain_exactly(
        :id,
        :image,
        :title,
        :url,
        :item_count
      )
  end

  it 'removes the the nil valued attributes from json' do
    attributes = collect_nil_value_attributes(subject)
    serialization = ActiveModelSerializers::Adapter.create(subject)
    restuarant_hash = JSON.parse(serialization.to_json)

    attributes.each do |attr|
      expect(restuarant_hash['restaurant'].key?(attr.to_s)).not_to eq true
    end
  end
end

def collect_nil_value_attributes(subject)
  subject.attributes.select { |_, value| value.nil? }.keys
end
