class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :mercari_users
  has_many :items
  has_many :exhibit_historys
end
