class Item < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :mercari_user, required: true

  validates :image1, presence: true
  validates :item_name, presence: true, length: { maximum: 40 }
  validates :category, presence: true
  validates :shipping_duration, presence: true
  validates :item_condition, presence: true
   # メルカリで出品できる範囲が、300円から9,999,999円の範囲
  validates :price, presence: true, inclusion: { in: 300..9999999 }
  validates :shipping_from_area, presence: true, inclusion: { in: 1..47 }
  validates :contents, length: { maximum: 1000 }

  def getItemCondition
    options = ItemConstant::ITEM_CONDITION_OPTIONS
    return options[self.item_condition-1]
  end

  def getShippingDuration
    options = ItemConstant::SHIPPING_DURATION_OPTIONS
    return options[self.shipping_duration-1]
  end

  def getShippingFromArea
    options = ItemConstant::SHIPPING_FROM_AREA_OPTIONS
      return options[self.shipping_from_area-1]
  end

  # 自動出品をするかを返す
  def getAutoExhibitFlag
    if self.auto_exhibit_flag?
      return ItemConstant::AUTO_EXHIBIT_FLAG_OPTIONS[0]
    else
      return ItemConstant::AUTO_EXHIBIT_FLAG_OPTIONS[1]
    end
  end

end
