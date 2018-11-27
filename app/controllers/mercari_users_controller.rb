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
    mercari_user = MercariUser.find_by(id: params['mercari_user_id'])
    mercari_user.deleteMercariUser
    flash[:success] = 'メルカリアカウントを削除しました'
    redirect_to mercari_users_path
  end

  def update_mercari_auth_token
    mercari_user = MercariUser.find_by(id: params['mercari_user_id'])
    if mercari_user.updateAutoToken()
      flash[:success] = 'メルカリ認証トークンを更新しました'
    else
      flash[:danger] = 'メルカリ認証トークンの更新に失敗しました'
    end
    redirect_to mercari_users_path
  end

  # メルカリアカウント情報のstrongパラメータの設定
  private
  def mercari_user_params
    params.require(:mercari_user).permit(:name, :email, :password, :image_full_filepath, :image_full_filepath_cache)
  end
end
