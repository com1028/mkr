require 'fileutils'

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
        # @mercari_user.setMercariToken()
        @mercari_user.access_token = "aaa"
        @mercari_user.global_access_token = "bbb"
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
            # メルカリユーザの商品データを削除
            delete_user.items.delete_all
            # 関連する商品データ画像の削除

            # メルカリユーザの削除
            delete_user.delete
            # 関連するメルカリアカウントのアイコン画像の削除
            delete_dir = "#{Rails.root}/public/#{delete_user.user.class.to_s.underscore}/#{delete_user.user.id}/#{delete_user.class.to_s.underscore}/icon/#{delete_user.id}"
            FileUtils.rm_r(delete_dir)
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
