class MercariUsersController < ApplicationController
    def index
        @mercari_users = current_user.mercari_users
    end

    def new
        @mercari_user = MercariUser.new
    end

    def create
        @mercari_user = current_user.mercari_users.new(mercari_user_params)
        @mercari_user.access_token = "access_token_params"
        @mercari_user.global_access_token = "global_access_token_params"
        # binding.pry
        if @mercari_user.save
        # ユーザの作成に成功した場合
        flash[:success] = "ユーザ登録が完了しました"
        redirect_to mercari_users_path
        else
        # ユーザの作成に失敗した場合
        render 'new'
    end
        # redirect_to new_mercari_user_path
    end

      # メルカリアカウント情報のstrongパラメータの設定
    private def mercari_user_params
        params.require(:mercari_user).permit(:name, :email, :password)
    end

end
