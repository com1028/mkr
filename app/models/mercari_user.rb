class MercariUser < ApplicationRecord
  belongs_to :user, required: true

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :access_token, presence: true
  validates :global_access_token, presence: true

  def setMercariToken()
    return if !fill_in_form?()
    self.access_token = getAccessToken()
    tmp_global_access_token = getGlobalAccessToken()
    self.global_access_token = getCorrectGlobalAccessToken(tmp_global_access_token)
  end

  def fill_in_form?
    if self.email.length() == 0 || self.password.length() == 0 || self.name.length() == 0
      return false
    else
      return true
    end
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
        # puts res.code
        # puts res.body
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
          #  puts res.code
          #  puts res.body
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
        return
      end

    end

end
