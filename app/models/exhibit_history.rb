class ExhibitHistory < ApplicationRecord
	belongs_to :user, required: true
	belongs_to :mercari_user, required: true
	belongs_to :item, required: true

	validates :mercari_item_token, presence: true, uniqueness: true

	#	特定のメルカリIDの商品をメルカリ上から削除
	def deleteItemFromMercari
		# 出品中の商品削除はJavaのAPIを通して行うので、Linux上でjavaコマンドを生成して実行する
		cmd = "java -jar #{APIConstant::API_PATH}/deleteAPI.jar #{mercari_item_token} #{mercari_user.access_token} #{mercari_user.global_access_token}"
		result = `#{cmd}`
		self.delete
	end

	def existComment?
		uri = URI.parse("https://api.mercari.jp/items/get?_global_access_token=#{mercari_user.global_access_token}&_item_photo_format=detail&id=#{mercari_item_token}&_access_token=#{mercari_user.access_token}")

		req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
		req["Host"] = "api.mercari.jp"
		req["Accept-Language"] = "ja-jp"
		req["Connection"] = "keep-alive"
		req["Accept"] = "application/json"
		req["User-Agent"] = "Mercari_r/5311 (iPhone OS 9.3.3; ja-JP; iPhone8,1)"
		req["X-APP-VERSION"] = "2501"
		req["X-PLATFORM"] = "ios"

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = (uri.scheme == 'https') # これ無いとSSLページ接続時に「end of file reached (EOFError)」というエラー出る
		res = http.request(req)

		case res
		when Net::HTTPSuccess, Net::HTTPRedirection
			#	OK
			if res.body.try(:include?, "\"num_comments\":0")
				return false
			else
				return true
			end
		else
			#	NG
			return false
		end

	end

end
