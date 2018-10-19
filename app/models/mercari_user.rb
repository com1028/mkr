class MercariUser < ApplicationRecord
  belongs_to :user, required: true

  validates :email, presence: true
  validates :password, presence: true
  validates :name, presence: true
  validates :access_token, presence: true
  validates :global_access_token, presence: true

end
