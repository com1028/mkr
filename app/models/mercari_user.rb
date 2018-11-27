class MercariUser < ApplicationRecord
  belongs_to :user, required: true
  has_many :items
  has_many :exhibit_historys

  before_validation :setMercariToken

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :access_token, presence: true
  validates :global_access_token, presence: true
  validates :image_full_filepath, presence: true
  validates :exhibit_interval, :numericality => {greater_than_or_equal_to: 2}

  mount_uploader :image_full_filepath, ImageUploader

  scope :in_not_progress_user, -> (id){find_by(id: id, in_progress: false)}
  scope :in_progress_user, -> (id){find_by(id: id, in_progress: true)}

  # 全ての「自動出品中」ユーザを取得
  scope :all_in_progress_user, -> {where(in_progress: true)}

  def getAuthToken
    self.access_token = getAccessToken()
    tmp_global_access_token = getGlobalAccessToken()
    self.global_access_token = getCorrectGlobalAccessToken(tmp_global_access_token)
  end

  def updateAutoToken
    self.getAuthToken()
    if self.save
      return true
    else
      return false
    end
  end

  def setMercariToken()
    return if !fill_in_form?()
    if self.email_changed? || self.password_changed?
      self.getAuthToken()
    end
  end

  def fill_in_form?
    if self.email.length() == 0 || self.password.length() == 0 || self.name.length() == 0
      return false
    else
      return true
    end
  end

  def deleteMercariUser
    # メルカリユーザの商品データを削除
    items.each do |item|
      item.deleteItem
    end
    # 関連するメルカリアカウントのアイコン画像の削除
    delete_dir = "#{Rails.root}/public/#{self.user.class.to_s.underscore}/#{self.user.id}/#{self.class.to_s.underscore}/icon/#{self.id}"
    FileUtils.rm_r(delete_dir)
    # メルカリユーザの削除
    delete
  end

  private

  require 'net/http'
    def getAccessToken()
      uuid = SecureRandom.uuid.upcase.gsub('-', '')
      uri = URI.parse("https://api.mercari.jp/auth/create_token?uuid=#{uuid}")

      req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      req["Host"] = "api.mercari.jp"
      #req["Accept-Encoding"] = "gzip, deflate"
      req["Connection"] = "close"
      req["User-Agent"] = "Mercari_r/5311 (iPhone OS 9.3.3; ja-JP; iPhone8,1)"
      req["Accept"] = "application/json"
      req["Accept-Language"] = "ja-jp"
      req["X-PLATFORM"] = "ios"
      req["X-APP-VERSION"] = "5311"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https') # これ無いとSSLページ接続時に「end of file reached (EOFError)」というエラー出る
      res = http.request(req)

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        re = Regexp.new('(access_token":"(.*?)")')
        m = re.match(res.body)
        return m[2]
      else
        # NG
        puts "-------------------------------------------Access Token-------------------------------------"
        puts res.code
        puts res.body
        puts "---------------------------------------------------------------------------------------------"

      end

    end

    def getGlobalAccessToken()
      access_token = self.access_token
      uri = URI.parse("https://api.mercari.jp/global_token/get?_access_token=#{access_token}")

      req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
      req["Host"] = "api.mercari.jp"
      #req["Accept-Encoding"] = "gzip, deflate"
      req["Connection"] = "close"
      req["User-Agent"] = "Mercari_r/5311 (iPhone OS 9.3.3; ja-JP; iPhone8,1)"
      req["Accept"] = "application/json"
      req["Accept-Language"] = "ja-jp"
      req["X-PLATFORM"] = "ios"
      req["X-APP-VERSION"] = "5311"

      http = Net::HTTP.new(uri.host, uri.port)
         http.use_ssl = (uri.scheme == 'https') # これ無いとSSLページ接続時に「end of file reached (EOFError)」というエラー出る
         res = http.request(req)

         case res
         when Net::HTTPSuccess, Net::HTTPRedirection
           # OK
           re = Regexp.new('(global_access_token":"(.*?)")')
           m = re.match(res.body)
           return m[2]
         else
           # NG
        # NG
        puts "-------------------------------------------Global Access Token(正しくない方)-------------------------------------"
        puts res.code
        puts res.body
        puts "----------------------------------------------------------------------------------------------------------------"
         end

    end

    def getCorrectGlobalAccessToken(tmp_global_access_token)
      access_token = self.access_token
      mercari_email = self.email
      mercari_password = self.password

      uri = URI.parse("https://api.mercari.jp/users/login?_global_access_token=#{tmp_global_access_token}&_access_token=#{access_token}")

      req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
      data = "iv_cert=3D2F6B778FE74D30A8C787D77A2134E3&email=#{mercari_email}&revert=check&password=#{mercari_password}"
      req.body = data
      req["Host"] = "api.mercari.jp"
      #req["Accept-Encoding"] = "gzip, deflate"
      req["Connection"] = "close"
      req["Content-Type"] = "application/x-www-form-urlencoded"
      req["User-Agent"] = "Mercari_r/5311 (iPhone OS 9.3.3; ja-JP; iPhone8,1)"
      req["Accept"] = "application/json"
      req["Accept-Language"] = "ja-jp"
      req["X-PLATFORM"] = "ios"
      req["X-APP-VERSION"] = "5311"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https') # これ無いとSSLページ接続時に「end of file reached (EOFError)」というエラー出る
      res = http.request(req)

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        re = Regexp.new('(global_access_token":"(.*?)")')
        m = re.match(res.body)
        return m[2]
      else
        # NG
        puts "-------------------------------------------Global Access Token-------------------------------------"
        puts res.code
        puts res.body
        puts "---------------------------------------------------------------------------------------------"
        return
      end

    end

end
