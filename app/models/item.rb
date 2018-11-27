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
  validates :contents, length: { in: 1..1000 }

  mount_uploader :image1, Image1Uploader
  mount_uploader :image2, Image2Uploader
  mount_uploader :image3, Image3Uploader
  mount_uploader :image4, Image4Uploader

  # 前回に自動出品した商品を取得
  scope :last_exhibit_item, -> (mercari_user_id){where(mercari_user_id: mercari_user_id).where.not(last_auto_exhibit_date: nil).first}
  # 次回出品する商品を取得
  scope :next_exhibit_item, -> (mercari_user_id, last_exhibit_item){last_exhibit_item.next(Item.where(mercari_user_id: mercari_user_id, auto_exhibit_flag: true), mercari_user_id)}

  # 特定のメルカリアカウントが最終自動出品を行った商品の数を取得（通常は0 or 1）
  scope :final_auto_exhibit_count, -> (mercari_user_id){where(mercari_user_id: mercari_user_id).where.not(last_auto_exhibit_date: nil).count}

  # 特定のメルカリアカウントにおける自動出品対象の商品の数を取得
  scope :auto_exhibit_count_by_mercari_user, -> (mercari_user_id){where(mercari_user_id: mercari_user_id, auto_exhibit_flag: true).count}

  # 商品名が検索結果と一部でもマッチする商品を取得
  scope :word_search, -> (s_word){where("item_name like '%" + s_word + "%'")}

  def getItemCondition
    options = ItemConstant::ITEM_CONDITION_OPTIONS
    return options[item_condition-1]
  end

  def getShippingDuration
    options = ItemConstant::SHIPPING_DURATION_OPTIONS
    return options[shipping_duration-1]
  end

  def getShippingFromArea
    options = ItemConstant::SHIPPING_FROM_AREA_OPTIONS
    return options[shipping_from_area-1]
  end

  # 自動出品をするかを返す
  def getAutoExhibitFlag
    if auto_exhibit_flag?
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
    item = items.where(mercari_user_id: mercari_user_id, auto_exhibit_flag: true).where("id > ?", id).order("id ASC").first
    item ||= Item.where(mercari_user_id: mercari_user_id, auto_exhibit_flag: true).first
  end

  def exhibit
    # メルカリへの出品はJavaのAPIを通して行うので、Linux上でjavaコマンドを生成して実行する
    cmd = "java -jar #{APIConstant::API_PATH}/exhibitAPI.jar #{mercari_user.global_access_token} #{mercari_user.access_token} #{mercari_user.refresh_token} #{getImageFullPath(image1.to_s)} #{getImageFullPath(image2.to_s)} #{getImageFullPath(image3.to_s)} #{getImageFullPath(image4.to_s)} '#{item_name}' '#{contents}' #{category} #{item_condition} #{shipping_payer} #{shipping_method} #{shipping_from_area} #{shipping_duration} #{price}"
    result = `#{cmd}`
    if result.start_with?("m") && !result.include?("\n")
      # 出品成功時の処理
      exhibit_history = ExhibitHistory.new(item_id: id, mercari_user_id: mercari_user.id, user_id: user.id, mercari_item_token: result)
      exhibit_history.save
    else
      # 出品失敗時の処理
      binding.pry
      # re_exhibit()
    end
  end

  # 出品失敗時に認証トークンを再取得して出品を試みる
  def re_exhibit
    # 認証トークンを更新
    self.mercari_user.updateAutoToken()
    # 再度、出品処理を実行
    cmd = "java -jar #{APIConstant::API_PATH}/exhibitAPI.jar #{mercari_user.global_access_token} #{mercari_user.access_token} #{getImageFullPath(image1.to_s)} #{getImageFullPath(image2.to_s)} #{getImageFullPath(image3.to_s)} #{getImageFullPath(image4.to_s)} '#{item_name}' '#{contents}' #{category} #{item_condition} #{shipping_payer} #{shipping_method} #{shipping_from_area} #{shipping_duration} #{price}"
    result = `#{cmd}`
    if result.start_with?("m") && !result.include?("\n")
      # 出品成功時の処理
      exhibit_history = ExhibitHistory.new(item_id: id, mercari_user_id: mercari_user.id, user_id: user.id, mercari_item_token: result)
      exhibit_history.save
    else
      # 出品失敗時の処理
      return false
    end
  end

  def deleteItem
    deleteItemFromMercari()
    delete()
    # 商品の画像を削除
    delete_dir = "#{Rails.root}/public/#{user.class.to_s.underscore}/#{user.id}/#{mercari_user.class.to_s.underscore}/icon/#{mercari_user.id}/item/#{id}"
    FileUtils.rm_r(delete_dir)

  end

  def deleteItemFromMercari
    exhibit_historys.each do |history|
      history.deleteItemFromMercari()
    end
  end

  def deleteIfNotExistComment
    exhibit_historys.each do |exhibit_history|
      unless exhibit_history.existComment?
        exhibit_history.deleteItemFromMercari()
      end
    end
  end

  private

  def setshipping_payer
    if shipping_method <= ItemConstant::SHIPPING_METHODS_BUYER.length
      # 購入者負担
      self.shipping_payer = 1
    else
      # 出品者負担
      self.shipping_payer = 2
    end
  end

end
