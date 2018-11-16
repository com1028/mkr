class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :mercari_users
  has_many :items
  has_many :exhibit_historys

  def delete_mercari_users(user_list)
    user_list.each do |list|
      delete_user = mercari_users.find_by(id:list)

      # メルカリユーザの商品データを削除
      delete_user.items.delete_all
      # 関連する商品データ画像の削除

      # メルカリユーザの削除
      delete_user.delete
      # 関連するメルカリアカウントのアイコン画像の削除
      delete_dir = "#{Rails.root}/public/#{delete_user.user.class.to_s.underscore}/#{delete_user.user.id}/#{delete_user.class.to_s.underscore}/icon/#{delete_user.id}"
      FileUtils.rm_r(delete_dir)
    end
  end

end
