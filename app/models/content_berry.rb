class ContentBerry < ApplicationRecord
  belongs_to :user, inverse_of: :content_berries
  belongs_to :restaurant, inverse_of: :content_berries
  belongs_to :item, inverse_of: :content_berries
  belongs_to :comment, inverse_of: :content_berries

  scope :restaurants, -> { joins(:restaurant) }
  scope :items, -> { joins(:item) }
  scope :comments, -> { joins(:restaurant) }

  def for_user
    send(self.type).user
  end

  def type
    [:restaurant, :item, :comment].each do |type|
      return type if send(type)
    end
  end
end
