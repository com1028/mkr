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
  validates :refresh_token, presence: true
  validates :image_full_filepath, presence: true
  validates :exhibit_interval, :numericality => {greater_than_or_equal_to: 2}

  mount_uploader :image_full_filepath, ImageUploader

  scope :in_not_progress_user, -> (id){find_by(id: id, in_progress: false)}
  scope :in_progress_user, -> (id){find_by(id: id, in_progress: true)}

  # 全ての「自動出品中」ユーザを取得
  scope :all_in_progress_user, -> {where(in_progress: true)}

  def getAuthToken
    setRefreshToken()
    # self.access_token = getAccessToken()
    # tmp_global_access_token = getGlobalAccessToken()
    # self.global_access_token = getCorrectGlobalAccessToken(tmp_global_access_token)
  end

  def updateAutoToken
    self.getAuthToken()
    if self.save
      return true
    else
      return false
    end
  end

  require 'net/http'

  def setRefreshToken
    uuid = SecureRandom.uuid.upcase.gsub('-', '')
    uri = URI.parse("https://api.mercari.jp/auth/refresh_token")
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Host"] = "api.mercari.jp"
    req["Content-Type"] = " application/x-www-form-urlencoded"
    req["Accept-Language"] = " ja-jp"
    req["Connection"] = " close"
    req["Accept"] = " application/json"
    req["User-Agent"] = " Mercari_r/18005 (iOS 12.0.1; ja-JP; iPhone11,8)"
    req["X-APP-VERSION"] = " 18005"
    req["X-PLATFORM"] = " ios"
    req.body = "uuid=#{uuid}"
    res = https.request(req)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
      re = Regexp.new('(refresh_token\":\"(.*?)")')
      m = re.match(res.body)
      self.refresh_token =  m[2]
      getAccessToken(uuid)
    else
      # NG
      puts "-------------------------------------------Refresh Token-------------------------------------"
      # puts uri
      # puts req
      puts res.code
      puts res.body
      puts "---------------------------------------------------------------------------------------------"

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
  
  def getGlobalAccessToken
    access_token = self.access_token
    uri = URI.parse("https://api.mercari.jp/global_token/get")

    req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
    req["Host"] = "api.mercari.jp"
    req["Accept-Language"] = "ja-jp"
    req["Connection"] = "close"
    req["Accept"] = "application/json"
    req["User-Agent"] = " Mercari_r/18005 (iOS 12.0.1; ja-JP; iPhone11,8)"
    req["X-APP-VERSION"] = "18005"
    #req["Accept-Encoding"] = "gzip, deflate"
    req["Authorization"] = "#{self.access_token}"
    req["X-PLATFORM"] = "ios"

    http = Net::HTTP.new(uri.host, uri.port)
       http.use_ssl = (uri.scheme == 'https') # これ無いとSSLページ接続時に「end of file reached (EOFError)」というエラー出る
       res = http.request(req)

       case res
       when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
        re = Regexp.new('(global_access_token":"(.*?)")')
        m = re.match(res.body)
        self.global_access_token = m[2]
        re2 = Regexp.new('(global_refresh_token":"(.*?)")')
        m2 = re2.match(res.body)
        authGlobalAccessToken()
       else
         # NG
      # NG
      puts "-------------------------------------------Global Access Token-------------------------------------"
      puts res.code
      puts res.body
      puts "----------------------------------------------------------------------------------------------------------------"
       end

  end

  def authGlobalAccessToken
    uri = URI.parse("https://api.mercari.jp/users/login?_global_access_token=#{self.global_access_token}")
    https = Net::HTTP.new(uri.host, uri.port)

    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Host"] = "api.mercari.jp"
    req["Accept"] = " application/json"
    req["Authorization"] = " #{self.access_token}"
    req["Accept-Language"] = " ja-jp"
    req["Content-Type"] = " application/x-www-form-urlencoded"
    req["User-Agent"] = " Mercari_r/18005 (iOS 12.0.1; ja-JP; iPhone11,8)"
    req["Connection"] = " close"
    req["X-APP-VERSION"] = " 18005"
    req["X-PLATFORM"] = " ios"

    req.body = "iv_cert=tekitouska&email=#{self.email}&revert=check&password=#{self.password}"
    res = https.request(req)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK

    else
      # NG
      puts "-----------------------------------------authGlobalAccessToken-------------------------------------"
      # puts uri
      # puts req
      puts res.code
      puts res.body
      puts "---------------------------------------------------------------------------------------------"

    end
  end

  def deleteMercariUser
    # メルカリユーザの商品データを削除
    items.each do |item|
      item.deleteItem()
    end
    # 関連するメルカリアカウントのアイコン画像の削除
    delete_dir = "#{Rails.root}/public/#{self.user.class.to_s.underscore}/#{self.user.id}/#{self.class.to_s.underscore}/icon/#{self.id}"
    FileUtils.rm_r(delete_dir)
    # メルカリユーザの削除
    delete()
  end

  def getAccessToken(uuid)
    uri = URI.parse("https://api.mercari.jp/auth/access_token")
    https = Net::HTTP.new(uri.host, uri.port)
    
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Host"] = "api.mercari.jp"
    req["Content-Type"] = " application/x-www-form-urlencoded"
    req["Accept-Language"] = " ja-jp"
    req["Connection"] = " close"
    req["Accept"] = " application/json"
    req["User-Agent"] = " Mercari_r/18005 (iOS 12.0.1; ja-JP; iPhone11,8)"
    req["X-APP-VERSION"] = " 18005"
    req["X-PLATFORM"] = " ios"
    req.body = "refresh_token=#{self.refresh_token}&uuid=#{uuid}"
    res = https.request(req)
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
      re = Regexp.new('(access_token\":\"(.*?)\")')
      m = re.match(res.body)
      self.access_token = m[2]
      getGlobalAccessToken()
    else
      # NG
      puts "-------------------------------------------Access Token-------------------------------------"
      # puts uri
      # puts req
      puts res.code
      puts res.body
      puts "---------------------------------------------------------------------------------------------"
  end


end



end
