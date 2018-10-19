class MercariUsersController < ApplicationController
    def index
        @mercari_users = current_user.mercari_users
    end

    def new
        @mercari_user = MercariUser.new
    end
end
