class ItemsController < ApplicationController
    def index
        @mercari_user = MercariUser.find_by(id: params['mercari_user_id'])
        @items = @mercari_user.items.all
    end
end
