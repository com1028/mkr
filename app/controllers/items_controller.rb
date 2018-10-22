class ItemsController < ApplicationController
    def index
        @mercari_user = current_user.mercari_users.find_by(id: params['mercari_user_id'])
        @items = @mercari_user.items.all
    end

    def new
        @mercari_user = current_user.mercari_users.find_by(id: params['mercari_user_id'])
        @item = Item.new
    end

    def create
        @mercari_user = current_user.mercari_users.find_by(id: item_params['mercari_user_id'])
        @item = @mercari_user.items.new(item_params)
        @item.user_id = current_user.id
        @item.image1 = "ダミーデータ"
        if @item.save
            # 商品データの作成に成功した場合
            flash[:success] = "商品を追加しました"
            redirect_to items_path(mercari_user_id: @mercari_user.id)
        else
            # 商品データの作成に失敗した場合
            render 'new'
        end
    end

    def delete_selected_item
        @mercari_user = nil
        item_id_list = params['itemlist']
        item_id_list.each_with_index do |list, i|
            delete_item = Item.find_by(id: list)
            if i == 0
                @mercari_user = delete_item.mercari_user
            end
            delete_item.delete
            # 商品の画像を削除
            # （サンプル）
            # delete_dir = "#{Rails.root}/public/#{delete_user.user.class.to_s.underscore}/#{delete_user.user.id}/#{delete_user.class.to_s.underscore}/icon/#{delete_user.id}"
            # FileUtils.rm_r(delete_dir)
        end
        flash[:success] = '商品を削除しました'
        # 商品一覧へリダイレクト
        redirect_to items_path(mercari_user_id: @mercari_user.id)
    end

    private
    def item_params
        params.require(:item).permit(:mercari_user_id, :image1, :image2, :image3, :image4, :item_name, :category, :shipping_duration, :item_condition, :price, :shipping_from_area, :contents, :auto_exhibit_flag)
    end

end
