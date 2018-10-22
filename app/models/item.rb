class Item < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :mercari_user, required: true

  validates :image1, presence: true
  validates :item_name, presence: true, length: { maximum: 40 }
  validates :category, presence: true
  validates :shipping_duration, presence: true
  validates :item_condition, presence: true
   # メルカリで出品できる範囲が、1,000円から999,999円の範囲？
  validates :price, presence: true, inclusion: { in: 1000..999999 }
  validates :shipping_from_area, presence: true
  validates :contents, presence: true, length: { maximum: 1000 }
  validates :auto_exhibit_flag, presence: true
end
