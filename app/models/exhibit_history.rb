class ExhibitHistory < ApplicationRecord
	belongs_to :user, required: true
	belongs_to :mercari_user, required: true
	belongs_to :item, required: true

	validates :mercari_item_token, presence: true, uniqueness: true
end
