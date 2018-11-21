class ItemsController < ApplicationController
    def index
      @mercari_user = current_user.mercari_users.find_by(id: params['mercari_user_id'])
      @items = @mercari_user.items.all
    end

    def new
      @mercari_user = current_user.mercari_users.find_by(id: params['mercari_user_id'])
      @item = Item.new
    end

    def edit
      @item = Item.find_by(id: params['id'])
      @mercari_user = @item.mercari_user
    end

    def update
      @mercari_user = current_user.mercari_users.find_by(id: item_params['mercari_user_id'])
      @item = @mercari_user.items.find_by(id: params['id'])
      if @item.update_attributes(item_params)
        # 商品データの編集に成功した場合
        flash[:success] = "商品を編集しました"
        redirect_to items_path(mercari_user_id: @mercari_user.id)
      else
        # 商品データの編集に失敗した場合
        render 'new'
      end
    end

    def create
      @mercari_user = current_user.mercari_users.find_by(id: item_params['mercari_user_id'])
      @item = @mercari_user.items.new(item_params)
      @item.user_id = current_user.id
      if @item.save
        # 商品データの作成に成功した場合
        flash[:success] = "商品を追加しました"
        redirect_to items_path(mercari_user_id: @mercari_user.id)
      else
        # 商品データの作成に失敗した場合
        render 'new'
      end
    end

    def update_selected_item
      @item = Item.find_by(id: item_params['id'])
      if @item.update_attributes(item_params)
        flash[:success] = "情報を編集しました"
        redirect_to items_path(mercari_user_id: @item.mercari_user.id)
      else
        flash[:danger] = @item.errors.full_messages
        redirect_to items_path(mercari_user_id: @item.mercari_user.id)
      end
    end

    def delete_selected_item
      mercari_user = nil
      item_id_list = params['itemlist']
      item_id_list.each_with_index do |list, i|
        delete_item = Item.find_by(id: list)
        if i == 0
          mercari_user = delete_item.mercari_user
        end
        delete_item.exhibit_historys.each do |history|
          history.deleteItemFromMercari
        end
        delete_item.delete
        # 商品の画像を削除
        delete_dir = "#{Rails.root}/public/#{delete_item.user.class.to_s.underscore}/#{delete_item.user.id}/#{delete_item.mercari_user.class.to_s.underscore}/icon/#{delete_item.mercari_user.id}/item/#{delete_item.id}"
        FileUtils.rm_r(delete_dir)
      end
      flash[:success] = '商品を削除しました'
      # 商品一覧へリダイレクト
      redirect_to items_path(mercari_user_id: mercari_user.id)
    end

    def delete_selected_item_from_mercari
      mercari_user = nil
      item_id_list = params['itemlist']
      item_id_list.each_with_index do |list, i|
        delete_item = Item.find_by(id: list)
        if i == 0
          mercari_user = delete_item.mercari_user
        end
        delete_item.exhibit_historys.each do |history|
          history.deleteItemFromMercari
        end
      end
      flash[:success] = 'メルカリから商品を削除しました'
      # 商品一覧へリダイレクト
      redirect_to items_path(mercari_user_id: mercari_user.id)
    end

    # 単体で出品
    def simple_exhibit
      item = Item.find_by(id: params['item_id'])
      item.exhibit
    end

    # 自動出品を開始
    def start_auto_exhibit
      auto_exhibit_user = MercariUser.in_not_progress_user(params['mercari_user_id'])
      auto_exhibit_user.update(in_progress: true) if auto_exhibit_user.present?
    end

    # 自動出品を停止
    def stop_auto_exhibit
      auto_exhibit_user = MercariUser.in_progress_user(params['mercari_user_id'])
      auto_exhibit_user.update(in_progress: false) if auto_exhibit_user.present?
    end

    private

    def item_params
      params.require(:item).permit(:id, :mercari_user_id, :image1, :image2, :image3, :image4, :item_name,
        :category, :shipping_duration, :item_condition, :price, :shipping_method, :shipping_from_area, :contents, :auto_exhibit_flag,
        :image1_cache, :image2_cache, :image3_cache, :image4_cache, :remove_image2, :remove_image3, :remove_image4)
    end
end
