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
  validates :shipping_from_area, presence: true, inclusion: { in: 1..47 }
  validates :contents, length: { maximum: 1000 }
  validates :auto_exhibit_flag, presence: true

  def getShippingFromArea
    options = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県",
			"埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県",
			"岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県",
			"鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県",
      "佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
      
      return options[self.shipping_from_area-1]
  end

  # 自動出品をするかを返す
  def getAutoExhibitFlag
    if self.auto_exhibit_flag?
      return 'する'
    else
      return 'しない'
    end
  end

end
