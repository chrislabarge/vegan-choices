FactoryBot.define do
  factory :item_photo do
    item nil
    photo { Rack::Test::UploadedFile.new(Rails.root.join('public', 'images', 'no-img.jpeg'), 'image/jpeg') }
    user nil
  end
end
