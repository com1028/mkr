class Item < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :mercari_user, required: true
  has_many :exhibit_historys

  before_validation :setshipping_payer

  validates :image1, presence: true
  validates :item_name, presence: true, length: { maximum: 40 }
  validates :category, presence: true
  validates :shipping_duration, presence: true, inclusion: { in: 1..ItemConstant::SHIPPING_DURATION_OPTIONS.length }
  validates :item_condition, presence: true, inclusion: { in: 1..ItemConstant::ITEM_CONDITION_OPTIONS.length }
   # メルカリで出品できる範囲が、300円から9,999,999円の範囲
  validates :price, presence: true, inclusion: { in: 300..9999999 }
  validates :shipping_method, presence: true, inclusion: { in: 1..(ItemConstant::SHIPPING_METHODS_BUYER.length +  ItemConstant::SHIPPING_METHODS_SELLER.length)}
  validates :shipping_payer, presence: true, inclusion: { in: 1..2 }
  validates :shipping_from_area, presence: true, inclusion: { in: 1..ItemConstant::SHIPPING_FROM_AREA_OPTIONS.length }
  validates :contents, length: { maximum: 1000 }

  mount_uploader :image1, Image1Uploader
  mount_uploader :image2, Image2Uploader
  mount_uploader :image3, Image3Uploader
  mount_uploader :image4, Image4Uploader

  # 前回に自動出品した商品を取得
  scope :last_exhibit_item, -> (mercari_user_id){where(mercari_user_id: mercari_user_id).where.not(last_auto_exhibit_date: nil).first}
  # 次回出品する商品を取得
  scope :next_exhibit_item, -> (mercari_user_id, last_exhibit_item){last_exhibit_item.next(Item.where(mercari_user_id: mercari_user_id, auto_exhibit_flag: true), mercari_user_id)}

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
  
  def getImageFullPath(image)
    if image.present?
      return "#{PathConstant::IMAGE_FILES_ROOT_PATH}#{image}"
    else
      return nil
    end
  end

  # 次の自動出品の商品を取得
  def next(items, mercari_user_id)
    item = items.where(mercari_user_id: mercari_user_id, auto_exhibit_flag: true).where("id > ?", self.id).order("id ASC").first
    if item.nil?
      item = Item.where(mercari_user_id: mercari_user_id, auto_exhibit_flag: true).first
    end
    return item
  end

  private

  def setshipping_payer
    if self.shipping_method <= ItemConstant::SHIPPING_METHODS_BUYER.length
      # 購入者負担
      self.shipping_payer = 1
    else
      # 出品者負担
      self.shipping_payer = 2
    end
  end

end
