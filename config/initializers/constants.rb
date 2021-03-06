module ItemConstant
  ITEM_CONDITION_OPTIONS = ["新品，未使用","未使用に近い","目立った傷や汚れなし",
    "やや傷や汚れあり","傷や汚れあり","全体的に状態が悪い"]
  SHIPPING_DURATION_OPTIONS = ["1〜2日で発送","2〜3日で発送","4〜7日で発送"]
  SHIPPING_FROM_AREA_OPTIONS =  ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県",
    "埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県",
    "岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県",
    "鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県",
  "佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
  AUTO_EXHIBIT_FLAG_OPTIONS = ["する", "しない"]
  SHIPPING_METHODS_BUYER = ["未定（着払い）", "ポスパケット（着払い）", "クロネコヤマト（着払い）", "ゆうパック（着払い）"]
  SHIPPING_METHODS_SELLER = ["未定（出品者負担）", "ゆうメール（出品者負担）", "ゆうパケット（出品者負担）", "レターパック（出品者負担）", "普通郵便（出品者負担）", 
    "クロネコヤマト（出品者負担）", "ゆうパック（出品者負担）", "はこBOON（出品者負担）", "クリップポスト（出品者負担）", "らくらくメルカリ便（出品者負担）"]
end

module APIConstant
  API_PATH = "lib/api"
end

module PathConstant
  IMAGE_FILES_ROOT_PATH = "#{Rails.root.to_s}/public"
end

module Fixed
  ITEM_PAGENATION_NUM = 10
  MERCARI_USER__PAGENATION_NUM = 5
end