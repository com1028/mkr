class MercariUsersController < ApplicationController
    def index
        @mercari_users = current_user.mercari_users
    end

    def new
    end
end
