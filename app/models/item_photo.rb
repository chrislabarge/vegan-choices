class ItemPhoto < ApplicationRecord
  mount_uploader :photo, ItemPhotoUploader

  belongs_to :item, inverse_of: :item_photos
  belongs_to :user, inverse_of: :item_photos

  attr_accessor :photo_cache, :remove_photo
end

