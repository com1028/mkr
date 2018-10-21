class MercariUsersController < ApplicationController
    def index
        @mercari_users = current_user.mercari_users
    end

    def new
        @mercari_user = MercariUser.new
    end

    def edit
        @mercari_user = current_user.mercari_users.find_by(id:params[:id])
    end

    def update
        @mercari_user = current_user.mercari_users.find_by(id:params[:id])
        # binding.pry
        if @mercari_user.update_attributes(mercari_user_params)
            # メルカリアカウントの作成に成功した場合
            flash[:success] = "メルカリアカウントの更新が完了しました"
            redirect_to mercari_users_path
        else
            # メルカリアカウントの作成に失敗した場合
            render 'new'
        end
    end

    def create
        @mercari_user = current_user.mercari_users.new(mercari_user_params)
        @mercari_user.setMercariToken()
         if @mercari_user.save
            # メルカリアカウントの作成に成功した場合
            flash[:success] = "メルカリアカウントの登録が完了しました"
            redirect_to mercari_users_path
        else
            # メルカリアカウントの作成に失敗した場合
            render 'new'
        end
    end

    def delete_selected_user
        user_id_list = params['userlist']
        user_id_list.each do |list|
            delete_user = current_user.mercari_users.find_by(id:list)
            delete_user.delete
        end
        flash[:success] = 'メルカリアカウントを削除しました'
        # メルカリアカウント一覧へリダイレクト
        redirect_to mercari_users_path
    end

    # メルカリアカウント情報のstrongパラメータの設定
    private 
    def mercari_user_params
        params.require(:mercari_user).permit(:name, :email, :password, :image_full_filepath, :image_full_filepath_cache)
    end
end
