require 'rails_helper'

RSpec.describe ItemImporter, type: :model do
  let(:item_type) { FactoryBot.build(:item_type) }
  let(:item) { FactoryBot.build(:item, item_type: item_type) }
  #TODO: Make an exporter class I can utilize here instead of the explict json formatter below.
  let(:data) { [item].to_json(except: [:id,
                                 :created_at,
                                 :updated_at,
                                 :restaurant_id, :item_type_id],
                        methods: [:restaurant_name, :type_name]) }

  let(:restaurant) { item.restaurant }

  subject { ItemImporter.new(data) }

  describe '#import' do
    context 'when there is a problem importing the data' do
      it 'displays importer record restaurant errors' do
        restaurant.destroy
        allow(subject).to receive(:puts)
        allow(subject).to receive(:puts).with(["Could not find the Restaurant named '#{restaurant.name}' for #{item.name}"])

        subject.import

        expect(subject).to have_received(:puts).with(["Could not find the Restaurant named '#{restaurant.name}' for #{item.name}"])
      end

      it 'displays importer record item type errors' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:puts).with(["Could not find the ItemType named 'item_type2' for #{item.name}"])

        subject.import

        expect(subject).to have_received(:puts).with(["Could not find the ItemType named 'item_type2' for #{item.name}"])
      end

      it 'creates a importer data type runtime error' do
        expected = "\nPlease send valid JSON formatted data\n\n"

        begin ItemImporter.new('not a json file')
        rescue => e
          actual = e.message
        end

        expect(actual).to eq expected
      end

      it 'doesnt effect the import of other data records in the list' do
        restaurant.destroy
        another_item = FactoryBot.build(:item)
        data = [item, another_item].to_json(except: [:id,
                                 :created_at,
                                 :updated_at,
                                 :restaurant_id, :item_type_id],
                        methods: [:restaurant_name, :type_name])

        importer = ItemImporter.new(data)
        expected = Item.count + 1

        importer.import

        actual = Item.count

        expect(actual).to eq expected
      end
    end

    context 'when successfully importing the data' do
      it 'creates a new item when the data is is new' do
        item_type.save

        item_count = Item.count
        expected = item_count + 1

        subject.import

        actual = Item.count

        expect(actual).to eq expected
      end

      it 'updates an exisiting item when the data exists' do
        item.save
        item.item_type = nil

        item_count = Item.count
        expected = item_count

        subject.import

        actual = Item.count

        expect(actual).to eq expected
      end

      it 'creates and updates multiple items from data list' do
        item.save
        item.item_type = nil
        another_item = FactoryBot.build(:item)
        data = [item, another_item].to_json(except: [:id,
                                 :created_at,
                                 :updated_at,
                                 :restaurant_id, :item_type_id],
                        methods: [:restaurant_name, :type_name])
        item_count = Item.count
        expected = item_count + 1
        subject =  ItemImporter.new(data)

        subject.import

        actual = Item.count

        expect(actual).to eq expected
      end
    end
  end
end
