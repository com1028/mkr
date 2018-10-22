class Item < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :mercari_user, required: true
end
